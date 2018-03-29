Besu32 [![TravisCI build](https://travis-ci.org/thomasbhatia/besu32.svg?branch=master)](https://travis-ci.org/thomasbhatia/besu32) [![License](https://img.shields.io/badge/License-BSD-blue.svg)](LICENSE)
=====

By Thomas Bhatia (thomas.bhatia@eo.io)


Description
-----------


A fast [IETF RFC 4648][1] compliant Base32 library for Erlang.

Supports the following algorithms:

* Base32 alphabet
- [x] encoding
- [x] decoding


## Installation

Add Besu32 to your ```rebar.config``` dependencies:

    {deps, [
        {besu32,{git , "git@github.com:thomasbhatia/besu32.git", {tag, "v0.5.0"}}}
    ]}.

## Usage
#### Encode
    besu32:encode(<<"The quick brown fox jumps over the lazy dog">>).
    <<"KRUGKIDROVUWG2ZAMJZG653OEBTG66BANJ2W24DTEBXXMZLSEB2GQZJANRQXU6JAMRXWO===">>

#### Decode
    besu32:decode(<<"KRUGKIDROVUWG2ZAMJZG653OEBTG66BANJ2W24DTEBXXMZLSEB2GQZJANRQXU6JAMRXWO===">>).
    <<"The quick brown fox jumps over the lazy dog">>

## License

Besu32 is released under [BSD][2] (see [`LICENSE`](LICESNE)).

[1]: https://tools.ietf.org/html/rfc4648#page-8
[2]: https://opensource.org/licenses/BSD-3-Clause
