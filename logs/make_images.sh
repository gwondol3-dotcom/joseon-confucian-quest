#!/usr/bin/env bash
# 그림을 Codex로 한 장씩 차례대로 만드는 스크립트. 각 호출 기록은 logs/_log_이름.txt
cd "$(dirname "$0")/.." || exit 1
STYLE="Soft 3D clay toy render, rounded friendly shapes, gentle studio lighting, smooth matte surfaces, warm cheerful children's educational game style, hanji cream, ink navy and persimmon red accents. Absolutely no text, no letters, no characters, no watermark."
ICON="Single subject centered, whole subject visible with generous margin. Solid pure green background #00FF00, perfectly flat and uniform, no floor, no cast shadow on the background. Do not use bright pure green on the subject."
SCENE="Wide landscape 3:2 scene whose edges fade softly into a very pale off-white background."

gen(){ # $1=이름 $2=icon|scene $3=설명
  local name="$1" kind="$2" desc="$3" out tail
  if [ "$kind" = icon ]; then out="assets/$name-raw.png"; tail="$ICON"; else out="assets/$name.png"; tail="$SCENE"; fi
  [ -s "$out" ] && { echo "skip $name"; return; }
  local before; before=$(ls -t ~/.codex/generated_images/*/*.png ~/.codex/generated_images/*.png 2>/dev/null | head -1)
  codex exec -s workspace-write --skip-git-repo-check \
    "내장 image_gen 도구(gpt-image-2)로 이미지 1장을 생성해 ./$out 로 저장. 프롬프트: $desc $STYLE $tail" \
    < /dev/null > "logs/_log_$name.txt" 2>&1
  if [ ! -s "$out" ]; then
    local latest; latest=$(ls -t ~/.codex/generated_images/*/*.png ~/.codex/generated_images/*.png 2>/dev/null | head -1)
    if [ -n "$latest" ] && [ "$latest" != "$before" ]; then cp "$latest" "$out"; echo "copied $name from generated_images"; fi
  fi
  [ -s "$out" ] && echo "ok $name" || echo "FAIL $name"
}

gen kkabi icon "A cute friendly magpie mascot bird with black and white feathers and a little blue sheen, wearing a small black Joseon-era Korean gat hat tied under its chin, big sparkling eyes, holding a tiny calligraphy brush in one wing and waving the other."
gen title scene "A peaceful Joseon-era Korean village at the foot of green mountains, a grand Confucian academy gate with red pillars and a curved tiled roof in the center, children in white and pastel hanbok walking toward it, pine trees and a small stream."
gen gate scene "A grand closed wooden gate of a Joseon royal examination hall with thick red pillars and a curved blue-green tiled roof, the two heavy doors shut and secured by one big round brass lock, stone steps in front."
gen gateopen scene "The same grand Joseon examination hall gate with red pillars and tiled roof, both doors wide open with warm golden light shining out, pink flower petals floating in the air."
gen m1 scene "A kind Joseon scholar official in a blue robe handing out illustrated picture books to curious villagers, farmers and children, in front of a thatched-roof village."
gen m2 scene "The courtyard of a Joseon government office with a tiled-roof hall, a dignified magistrate in a red official robe seated on a raised wooden floor, stacked law books and scrolls on a low desk beside him."
gen m3 scene "A joyful traditional Korean wedding ceremony in a hanok courtyard, a groom in a blue official robe and a bride in a colorful red-and-green wonsam robe facing each other across a ceremonial table with a pair of wooden geese, family members smiling."
gen m4 scene "A busy Joseon street scene with four kinds of people: a scholar in a white robe and black gat reading a book, a doctor in a gray-blue robe with herbal medicine, a farmer with a hoe carrying vegetables, and a servant carrying firewood on an A-frame back carrier."
gen m5 scene "The inner courtyard of a Joseon hanok house, a mother in a long skirt hanbok gently teaching her young daughter embroidery on the wooden porch, flower pots and a stone well."
gen m6 scene "A child in hanbok sitting at a low wooden desk in a warm hanok room with paper sliding doors, writing in a stitched notebook with a calligraphy brush, an inkstone and a small oil lamp beside."
gen choi1 scene "Joseon-style storybook scene in a deep mountain forest: a middle-aged man in plain hanbok gathering firewood, and a large orange tiger peeking from behind the trees. Gentle and not scary, no blood."
gen choi2 scene "Joseon-style storybook scene in a mountain forest: a brave fifteen-year-old boy in hanbok holding a wood axe, standing firmly and facing a large orange tiger, determined expression. Not scary, no blood, no violence shown."
gen choi3 scene "Joseon-style storybook scene on a quiet sunny hillside: a boy in white mourning hanbok respectfully bowing in front of a newly made round grassy grave mound, pine trees around."
gen choi4 scene "Joseon-style storybook scene on a hillside: a small thatched hut built right next to a round grassy grave mound, a young man in white hanbok sitting quietly in front of the hut, seasons changing with falling leaves and snow on one side."
gen book1 icon "An old Korean traditional stitched-bound book with a hanji paper cover and red thread binding, opened to show simple ink brush illustrations of people with no writing."
gen law icon "A neat stack of three thick old Korean stitched law books with dark navy blue covers and red thread binding, closed, blank covers."
gen goose icon "A pair of carved wooden Korean wedding geese (mokgireogi) painted with soft red, blue and yellow accents, sitting on folded red silk cloth."
gen hopae icon "A traditional Korean Joseon wooden identity tag (hopae), a small rectangular wooden plaque with a rounded top and a red silk tassel cord hanging from it, blank wooden surface."
gen norigae icon "A traditional Korean norigae ornament: a jade butterfly pendant with a knotted red silk cord and long colorful silk tassels."
gen diary icon "A small traditional Korean stitched notebook lying on a wooden tray next to a calligraphy brush and a black inkstone."
gen hongpae icon "A rolled-up red paper scroll certificate tied with a golden ribbon, with a small pink flower ornament, celebratory."
gen yangban icon "A cute chibi Joseon scholar nobleman in a white robe and a black wide-brimmed gat hat, holding a book, calm smile."
gen jungin icon "A cute chibi Joseon doctor in a gray-blue robe and small black hat, holding a pouch of herbal medicine and a small mortar."
gen sangmin icon "A cute chibi Joseon farmer in plain white cotton clothes and a straw hat, holding a hoe and a basket of vegetables, cheerful."
gen cheonmin icon "A cute chibi Joseon servant in plain brown cotton clothes and a headband, carrying an A-frame wooden back carrier (jige) loaded with firewood, hardworking smile."
echo DONE
