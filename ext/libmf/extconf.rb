require 'mkmf'
require 'rbconfig'

system(RbConfig.ruby, '-r', File.expand_path('builder.rb', File.dirname(__FILE__)), '-e', 'Libmf::Builder.make')

create_makefile 'libmf/libmf'
