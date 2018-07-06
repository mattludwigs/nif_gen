# NifGen
Generate a new mix project with a NIF.

## Usage
```bash
# this only needs to be done once.
$ mix archive.install hex nif_gen "~> 1.0" --force
Resolving Hex dependencies...
Dependency resolution completed:
New:
  nif_gen 1.0.0
* Getting nif_gen (Hex package)
Compiling 1 file (.ex)
Generated nif_gen app
Generated archive "nif_gen-1.0.0.ez" with MIX_ENV=prod
* creating /home/connor/.asdf/installs/elixir/1.6.6/.mix/archives/nif_gen-1.0.0

# Generate a new app
$ mix nif_gen.new hello_nif
* creating hello_nif/config/config.exs
* creating hello_nif/test/test_helper.exs
* creating hello_nif/test/hello_nif_test.exs
* creating hello_nif/lib/hello_nif.ex
* creating hello_nif/.gitignore
* creating hello_nif/.formatter.exs
* creating hello_nif/mix.exs
* creating hello_nif/README.md
* creating hello_nif/Makefile
* creating hello_nif/c_src/hello_nif/hello_nif.c
* creating hello_nif/c_src/hello_nif/hello_nif.h
* creating hello_nif/c_src/hello_nif/hello_nif.mk

Fetch and install dependencies? [Yn] y
* running mix deps.get
Your Elixir nif project was created successfully.

# Change to the new app directory.
$ cd hello_nif
# Run tests.
$ mix test
==> elixir_make
Compiling 1 file (.ex)
Generated elixir_make app
==> hello_nif
mkdir -p /home/connor/oss/crazyflie/hello_nif/priv
cc -c -I/home/connor/.asdf/installs/erlang/21.0.1/usr/include -fPIC -Wall -Wextra -O2 -DDEBUG -g -o /home/connor/oss/crazyflie/hello_nif/c_src/hello_nif/hello_nif.o /home/connor/oss/crazyflie/hello_nif/c_src/hello_nif/hello_nif.c
cc /home/connor/oss/crazyflie/hello_nif/c_src/hello_nif/hello_nif.o -L/home/connor/.asdf/installs/erlang/21.0.1/usr/lib -fPIC -shared -pedantic -o /home/connor/oss/crazyflie/hello_nif/priv/hello_nif_nif.so
Compiling 1 file (.ex)
Generated hello_nif app
rt_dtor called
.

Finished in 0.02 seconds
1 test, 0 failures

Randomized with seed 466953

# Add numbers together.
$ iex -S mix
Erlang/OTP 21 [erts-10.0.1] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe]

==> elixir_make
Compiling 1 file (.ex)
Generated elixir_make app
==> hello_nif
make: Nothing to be done for 'all'.
Compiling 1 file (.ex)
Generated hello_nif app
Interactive Elixir (1.6.6) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> {:ok, r} = HelloNif.init()
{:ok, #Reference<0.4278161458.1745223681.167193>}
iex(2)> HelloNif.add(r, 1)
101
iex(3)> HelloNif.add(r, 1)
102
```
