rm -f test/render/fixtures/*.json
rm -f test/render/fixtures/*.scjson
rm -f test/render/fixtures/*.scxml
rm -f test/render/fixtures/*.svg
find -X test/render/fixtures/*.smcat -exec bin/smcat -T json  {} ";" & \
find -X test/render/fixtures/*.smcat -exec bin/smcat -T scjson  {} ";" & \
find -X test/render/fixtures/*.smcat -exec bin/smcat -T scxml  {} ";" & \
find -X test/render/fixtures/*.smcat -exec bin/smcat -T svg  {} ";"
bin/smcat -T json test/parse/fixtures/composite.smcat
bin/smcat -T dot test/parse/fixtures/composite.smcat
bin/smcat -T html test/parse/fixtures/composite.smcat
bin/smcat -T dot --direction left-right test/parse/fixtures/composite.smcat -o test/parse/fixtures/composite-left-right.dot
bin/smcat -T json test/parse/fixtures/composite_no_root_transitions.smcat
bin/smcat -T dot test/parse/fixtures/composite_no_root_transitions.smcat
bin/smcat -T html test/parse/fixtures/composite_no_root_transitions.smcat
bin/smcat -T json test/parse/fixtures/kitchensink.smcat
bin/smcat -T dot test/parse/fixtures/kitchensink.smcat
bin/smcat -T html test/parse/fixtures/kitchensink.smcat
bin/smcat -T json test/parse/fixtures/minimal.smcat
bin/smcat -T dot test/parse/fixtures/minimal.smcat
bin/smcat -T html test/parse/fixtures/minimal.smcat
bin/smcat -T dot test/parse/fixtures/pseudostates.smcat
bin/smcat -T json test/parse/fixtures/pseudostates.smcat
bin/smcat -T html test/parse/fixtures/states-with-a-label.smcat
bin/smcat -T dot test/parse/fixtures/states-with-a-label.smcat
bin/smcat -T json test/parse/fixtures/states-with-a-label.smcat