#!/bin/bash

cc=gcc
deps='utopia fract imgtool photon mass glee gleex glui ethnic nano nerv'
name=libplayground

inc=(
    -I.
    -Iinclude/
)

src=imgtool/src/gif/*.c
for arg in $deps
do
    src="${src} ${arg}/src/*.c"
    inc="${inc} -I${arg}"
done

flags=(
    -std=c99
    -Wall
    -Wextra
    -O2
)

lib=(
    -lglfw
    -lfreetype
    -lenet
    -lz
    -lpng
    -ljpeg
)

linux=(
    -lm
    -lGL
    -lGLEW
)

mac=(
    -framework OpenGL
    -mmacos-version-min=10.9
)

mac_dlib() {
    $cc ${flags[*]} ${inc[*]} ${mac[*]} ${lib[*]} -dynamiclib $src -o $name.dylib &&\
    install_name_tool -id @executable_path/$name.dylib $name.dylib 
}

linux_dlib() {
    $cc -shared ${flags[*]} ${inc[*]} ${lib[*]} ${linux[*]} -fPIC $src -o $name.so 
}

dlib() {
    if echo "$OSTYPE" | grep -q "darwin"; then
        mac_dlib
    elif echo "$OSTYPE" | grep -q "linux"; then
        linux_dlib
    else
        echo "OS is not supported yet..." && exit
    fi
}

slib() {
    $cc ${flags[*]} ${inc[*]} -c $src && ar -crv $name.a *.o && rm *.o
}

case "$1" in
    "-d")
        dlib;;
    "-s")
        slib;;
    *)
        echo "Run with -d to build dynamically, or -s to build statically." && exit;;
esac
