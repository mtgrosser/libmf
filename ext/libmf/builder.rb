require 'tempfile'
require 'pathname'
require 'shellwords'
require 'rbconfig'

module Libmf
  module Builder
    class << self
      SRCDIR = Pathname.new(__dir__)
      LIBDIR = Pathname.new(__dir__).parent.parent.join('lib', 'libmf')
      
      def make
        if Gem.win_platform?
          make_win
        elsif RbConfig::CONFIG['host_os'] =~ /darwin/i
          make_darwin
        else
          make_linux
        end
      end
      
      def make_win
        raise 'Compilation currently not supported on Windows'
      end
      
      def make_darwin
        make_unix('libmf.2.dylib', 'libmf.dylib')
      end
      
      def make_linux
        make_unix('libmf.so.2', 'libmf.so')
      end
      
      private

      def in_build_dir
        Dir.mktmpdir do |dir|
          tmpdir = Pathname.new(dir)
          %w[mf.cpp mf.def mf.h].each do |file|
            tmpdir.join(file).write(SRCDIR.join(file).read)
          end
          yield tmpdir
        end
      end

      def make_unix(build_name, target_name)
        in_build_dir do |tmpdir|
          build = tmpdir.join(build_name)
          target = LIBDIR.join(target_name)
          tmpdir.join('Makefile').write(SRCDIR.join('Makefile').read)
          system(%{make -C #{Shellwords.escape(tmpdir)} lib DFLAG="" OMPFLAG=""})
          raise 'Compilation error!' unless build.exist?
          target.binwrite(build.binread)
          target.chmod(0755)
        end
      end

    end
  end
end
