# Quadra - a multiplayer action puzzle game
# Copyright (C) 2000  Pierre Phaneuf
#
# This library is free software; you can redistribute it and/or modify
# it under the terms of the GNU Library General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Library General Public License for more details.
#
# You should have received a copy of the GNU Library General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.
#
# $Id$

.PHONY: clean distclean dustclean maintainerclean dist installdirs install

dustclean:
	rm -f $(wildcard $(shell find . -name 'core' -print) $(shell find . -name '*~' -print) $(shell find . -name '.#*' -print))

clean: dustclean
	rm -f $(wildcard $(CLEAN) $(TARGETS))

distclean: clean
	rm -f $(wildcard $(DISTCLEAN))

maintainerclean: distclean
	rm -f $(wildcard $(REALCLEAN))

dist: distclean quadra.spec configure manual-dist-stuff

installdirs:
	mkdir $(prefix)
	mkdir $(prefix)/games
	mkdir $(prefix)/lib
	mkdir $(prefix)/lib/games

install: installdirs $(TARGETS)
	$(INSTALL_PROGRAM) quadra $(prefix)/games/quadra
	$(INSTALL_PROGRAM) quadra-svga.so $(prefix)/lib/games/quadra-svga.so
	$(INSTALL_DATA) quadra.res $(prefix)/lib/games/quadra.res

quadra.spec: packages/quadra.spec.in source/config.cpp
	sed $< -e 's/@VERSION@/$(VERSION)/g' > $@

configure: configure.in
	autoconf

.PHONY: manual-dist-stuff
manual-dist-stuff:
	@echo "remember to edit the version number in the following files:"
	@echo "VisualC++/quadra.rc"
	@echo "packages/readme-win32.txt"

ifeq ($(MAKECMDGOALS),dustclean)
NODEPENDS:=1
endif
ifeq ($(MAKECMDGOALS),clean)
NODEPENDS:=1
endif
ifeq ($(MAKECMDGOALS),distclean)
NODEPENDS:=1
endif
ifeq ($(MAKECMDGOALS),maintainerclean)
NODEPENDS:=1
endif
ifeq ($(MAKECMDGOALS),dist)
NODEPENDS:=1
endif

ifndef NODEPENDS

config/config.mk: config/config.mk.in configure
	@echo "Please run './configure'."
	@exit 1

config/depends.mk: config/config.mk
	@echo "Building dependencies file ($@)"
	@$(foreach DEP,$(CXXDEPS),$(COMPILE.cc) -M $(DEP) | sed -e 's|^.*:|$(dir $(DEP))&|' >> $@;)

-include config/depends.mk

endif

