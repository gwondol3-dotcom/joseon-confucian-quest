/**
 * 까비와 조선 과거 시험 대모험 - 학생 기록 받기
 * 스프레드시트 > 확장 프로그램 > Apps Script 에 이 코드를 붙여 넣고 웹 앱으로 배포하세요.
 *  - "기록" 탭: 학생이 보낸 기록이 한 줄씩 쌓여요.
 *  - "학생현황" 탭: 학생마다 한 줄, 지금 어디까지 했는지 보여 줘요.
 */
const LOG_SHEET = '기록';
const SUM_SHEET = '학생현황';
const LOG_HEAD = ['받은 시각', '학생 기기 시각', '반', '번호', '이름', '구분', '단계', '엽전', '신분', '내용'];
const SUM_HEAD = ['번호', '이름', '반', '진행 단계', '엽전', '신분', '가상 일기', '최종 결과', '마지막 기록'];

function doPost(e) {
  const lock = LockService.getScriptLock();
  lock.waitLock(20000);
  try {
    const d = JSON.parse(e.postData.contents);
    const ss = SpreadsheetApp.getActiveSpreadsheet();
    const log = sheet_(ss, LOG_SHEET, LOG_HEAD);
    log.appendRow([new Date(), d.at || '', d.class || '', d.no || '', d.name || '', d.kind || '',
                   d.stage || '', d.coins || 0, d.status || '', d.detail || '']);

    if (d.kind !== '시험') updateSummary_(ss, d);
    return out_({ ok: true });
  } catch (err) {
    return out_({ ok: false, error: String(err) });
  } finally {
    lock.releaseLock();
  }
}

function doGet() {
  return out_({ ok: true, message: '조선 과거 시험 기록 받기가 켜져 있어요.' });
}

function updateSummary_(ss, d) {
  const sh = sheet_(ss, SUM_SHEET, SUM_HEAD);
  const rows = sh.getDataRange().getValues();
  let r = -1;
  for (let i = 1; i < rows.length; i++) {
    if (String(rows[i][0]) === String(d.no) && String(rows[i][1]) === String(d.name)) { r = i + 1; break; }
  }
  if (r < 0) {
    sh.appendRow([d.no, d.name, d.class, '', 0, '', '', '', '']);
    r = sh.getLastRow();
  }
  sh.getRange(r, 4).setValue(d.stage || '');
  sh.getRange(r, 5).setValue(d.coins || 0);
  if (d.status) sh.getRange(r, 6).setValue(d.status);
  if (d.kind === '일기') sh.getRange(r, 7).setValue(d.detail || '');
  if (d.kind === '최종통과') sh.getRange(r, 8).setValue(d.detail || '');
  sh.getRange(r, 9).setValue(new Date());
  // 번호 순으로 정렬
  if (sh.getLastRow() > 2) sh.getRange(2, 1, sh.getLastRow() - 1, SUM_HEAD.length).sort({ column: 1, ascending: true });
}

function sheet_(ss, name, head) {
  let sh = ss.getSheetByName(name);
  if (!sh) {
    sh = ss.insertSheet(name);
    sh.appendRow(head);
    sh.getRange(1, 1, 1, head.length).setFontWeight('bold').setBackground('#fde9c9');
    sh.setFrozenRows(1);
  }
  return sh;
}

function out_(obj) {
  return ContentService.createTextOutput(JSON.stringify(obj)).setMimeType(ContentService.MimeType.JSON);
}
