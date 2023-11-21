# μT-Kernel 3.0 BSP for Raspberry Pi Pico (GNU make 版)

## 概要

トロンフォーラムから公開されている μT-Kernel 3.0 BSP (Board Support Package) の
Raspberry Pi Pico 向けビルドを GNU make で行うためのフォークです。
Eclipse は不要です。

なお、Raspberry Pi Pico 向けの開発環境、デバッグ環境について
詳細は下記 URL の各記事にて紹介していますので、必要に応じて
参照してください。

https://retrotecture.jp/index.html#picolab

## 開発環境

ビルドに必要なツールと動作確認を行ったバージョンは下記のとおりです。
インストール方法は付録 A を参照してください。

- arm-none-eabi-binutils 2.41
- arm-none-eabi-gcc 13.2.0
- arm-none-eabi-newlib 4.3.0.20230120
- GNU Make 4.3

なお、動作確認は FreeBSD 13.2 にて行いました。

## ソースコードの取得

pico_rp2040 ブランチを指定してこのリポジトリを clone してください。

```
% git clone https://github.com/mijinco0/mtk3-pico-gmake.git --branch pico_rp2040
```

## ビルド方法

```
% cd path/to/mtk3-pico-gmake/build_make/
% gmake
```

ビルドに成功すると build_make ディレクトリに mtk3pico.elf ファイルが得られます。
これを [UF2 形式](https://github.com/microsoft/uf2) に変換したい場合は
付録 B を参照してください。
UF2 ファイルを Pico のフラッシュメモリに書き込む方法は付録 C を参照してください。

## 付録 A: ツールチェインのインストール方法

### 1. 作業ディレクトリとインストール先ディレクトリの作成

ここではビルド作業用のディレクトリを ~/pico/arm-none-eabi-build、
インストール先のディレクトリを ~/pico/arm-none-eabi と想定して説明します。

```
% mkdir -p ~/pico/arm-none-eabi-build/ ~/pico/arm-none-eabi/
% cd ~/pico/arm-none-eabi-build/
% mkdir binutils-build/ gcc-build/ newlib-build/ gdb-build/
```

### 2. ソースコードを取得する

```
% cd ~/pico/arm-none-eabi-build/
% wget https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.xz
% wget https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz
% wget wget ftp://sourceware.org/pub/newlib/newlib-4.3.0.20230120.tar.gz
% tar Jxf binutils-2.41.tar.xz
% tar Jxf gcc-13.2.0.tar.xz
% tar xzf newlib-4.3.0.20230120.tar.gz
```

### 3. binutils

```
% cd ~/pico/arm-none-eabi-build/binutils-build
% ../binutils-2.41/configure --target=arm-none-eabi --prefix=/home/mijinco/pico/arm-none-eabi --with-cpu=cortex-m0plus --with-no-thumb-interwork --with-mode=thumb
% gmake all install
```

いまインストールした binutils のコマンド群は以降の作業で必要となるので、
パスを通しておきます。

```
% export PATH="$PATH:~/pico/arm-none-eabi/bin"
```

### 4. gcc と libgcc

```
% cd ~/pico/arm-none-eabi-build/gcc-build
% ../gcc-13.2.0/configure --target=arm-none-eabi --prefix=/home/mijinco/pico/arm-none-eabi --with-cpu=cortex-m0plus --enable-languages=c,c++ --without-headers --with-newlib --with-no-thumb-interwork --with-mode=thumb
% gmake all-gcc install-gcc
% gmake all-target-libgcc install-target-libgcc
```
### 5. Newlib

```
% cd ~/pico/arm-none-eabi-build/newlib-build
% ../newlib-4.3.0.20230120/configure --target=arm-none-eabi --prefix=/home/mijinco/pico/arm-none-eabi --disable-newlib-supplied-syscalls
% gmake all install
```

### 6. gcc (再)

Newlib への対応のため、再度 GCC を configure して make します。

```
% cd ~/pico/arm-none-eabi-build/gcc-build
% ../gcc-13.2.0/configure --target=arm-none-eabi --prefix=/home/mijinco/pico/arm-none-eabi --with-cpu=cortex-m0plus --enable-languages=c,c++ --with-newlib --with-no-thumb-interwork --with-mode=thumb
% gmake all-gcc install-gcc
```

## 付録 B: ELF を UF2 に変換する方法

ELF から UF2 へ変換するツールのソースコードが Raspberry Pi 公式の
[pico-sdk](https://github.com/raspberrypi/pico-sdk/) に
含まれています。これをコンパイルして build_make/tools ディレクトリに置いてくと、
make の際に ELF から UF2 への変換まで行います。具体的な手順は下記のとおりです。

```
% git clone https://github.com/raspberrypi/pico-sdk.git --branch master
% cd pico-sdk/tools/elf2uf2/
% c++ -o elf2uf2 -I../../src/common/boot_uf2/include main.cpp
% cp elf2uf2 path/to/mtk3-pico-gmake/build_make/tools/
```

## 付録 C: UF2 ファイルを Pico のフラッシュメモリに書き込む方法

1. Pico の BOOTSEL ボタンを押しながら USB ケーブルでパソコンに接続する。
2. マスストレージデバイスとして認識されるので、適当なマウントポイントにマウントする。
3. UF2 ファイルをコピーする。
4. アンマウントする。

```
# mount_msdosfs /dev/da1s1 /media
# cp path/to/mtk3-pico-gmake/build_make/mtk3pico.uf2 /media
# umount /media
```

<code>/dev/da1s1</code> の部分はお使いの環境に合わせて読み替えてください。
