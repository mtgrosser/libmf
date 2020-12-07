#ifndef RUBY_LIBMF
#define RUBY_LIBMF

#include "libmf.h"

VALUE mLibmf = Qnil;

void Init_libmf()
{
    mLibmf = rb_define_module("Libmf");
}

#endif
