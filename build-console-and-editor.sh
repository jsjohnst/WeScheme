#!/bin/sh

## Assumes closure-library is under $HOME/work/closure-library.
## We may want to include closure-library as one of the external
## submodules of WeScheme.
# ClosureDir="${HOME}/work/closure-library"

ClosureDir="$(dirname $(cd $(dirname $0) && pwd))/closure-library"

build() {
    mkdir -p `dirname war/$2`
    "${ClosureDir}/closure/bin/calcdeps.py" \
        -i war-src/$1 \
        -p "$ClosureDir" \
        -p war-src \
        -o script \
        > war/$2    
}


echo "Building properties file for JS"
## fill me in
cp wescheme.properties war/wescheme.properties
python bin/make-properties.py <wescheme.properties >war-src/js/wescheme-properties.js



echo "Building test application: if this fails, something's wrong, and closure-library hasn't been installed"
build test/test.js test/test-calc.js

echo "Building console"
build js/console.js js/console-calc.js

echo "Building view"
build js/view.js js/view-calc.js

echo "Building editor"
build js/openEditor/index.js js/openEditor/openEditor-calc.js



echo "buildtest splitframe"
build test/splitframe.js test/splitframe-calc.js
