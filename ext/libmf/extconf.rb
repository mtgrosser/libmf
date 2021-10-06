require 'mkmf'
require 'rbconfig'
require_relative 'builder'

Libmf::Builder.make

create_makefile 'libmf/libmf'
