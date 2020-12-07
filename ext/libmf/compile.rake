require 'tempfile'
require 'pathname'
require 'rbconfig'

def make_darwin(srcdir, tmpdir, libdir)
  build = tmpdir.join('libmf.2.dylib')
  target = libdir.join('libmf.dylib')
  tmpdir.join('Makefile').write(srcdir.join('Makefile').read)
  Dir.chdir(tmpdir) do
    system('make lib DFLAG="" OMPFLAG=""')
    raise 'Compilation error!' unless build.exist?
    target.binwrite(build.binread)
    target.chmod(0755)
  end
end

def make_linux
  build = tmpdir.join('libmf.so.2')
  target = libdir.join('libmf.so')
  tmpdir.join('Makefile').write(srcdir.join('Makefile').read)
  Dir.chdir(tmpdir) do
    system('make lib DFLAG="" OMPFLAG=""')
    raise 'Compilation error!' unless build.exist?
    target.binwrite(build.binread)
    target.chmod(0755)
  end
end

desc 'Compile the libmf library'
task :compile do
  srcdir = Pathname.new(__dir__)
  libdir = srcdir.parent.parent.join('lib', 'libmf')
  
  Dir.mktmpdir do |dir|
    tmpdir = Pathname.new(dir)
    %w[mf.cpp mf.def mf.h].each do |file|
      tmpdir.join(file).write(srcdir.join(file).read)
    end
    if Gem.win_platform?
      raise 'Compilation currently not supported on Windows'
    elsif RbConfig::CONFIG['host_os'] =~ /darwin/i
      make_darwin(srcdir, tmpdir, libdir)
    else
      make_linux(srcdir, tmpdir, libdir)
    end
  end
end
