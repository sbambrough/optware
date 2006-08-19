###########################################################
#
# perl-dbix-contextualfetch
#
###########################################################
	
PERL-DBIX-CONTEXTUALFETCH_SITE=http://search.cpan.org/CPAN/authors/id/T/TM/TMTM
PERL-DBIX-CONTEXTUALFETCH_VERSION=1.03
PERL-DBIX-CONTEXTUALFETCH_SOURCE=DBIx-ContextualFetch-$(PERL-DBIX-CONTEXTUALFETCH_VERSION).tar.gz
PERL-DBIX-CONTEXTUALFETCH_DIR=DBIx-ContextualFetch-$(PERL-DBIX-CONTEXTUALFETCH_VERSION)
PERL-DBIX-CONTEXTUALFETCH_UNZIP=zcat
PERL-DBIX-CONTEXTUALFETCH_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
PERL-DBIX-CONTEXTUALFETCH_DESCRIPTION=DBIx-ContextualFetch - Add contextual fetches to DBI.
PERL-DBIX-CONTEXTUALFETCH_SECTION=util
PERL-DBIX-CONTEXTUALFETCH_PRIORITY=optional
PERL-DBIX-CONTEXTUALFETCH_DEPENDS=perl, perl-dbi
PERL-DBIX-CONTEXTUALFETCH_SUGGESTS=
PERL-DBIX-CONTEXTUALFETCH_CONFLICTS=

PERL-DBIX-CONTEXTUALFETCH_IPK_VERSION=1

PERL-DBIX-CONTEXTUALFETCH_CONFFILES=

PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR=$(BUILD_DIR)/perl-dbix-contextualfetch
PERL-DBIX-CONTEXTUALFETCH_SOURCE_DIR=$(SOURCE_DIR)/perl-dbix-contextualfetch
PERL-DBIX-CONTEXTUALFETCH_IPK_DIR=$(BUILD_DIR)/perl-dbix-contextualfetch-$(PERL-DBIX-CONTEXTUALFETCH_VERSION)-ipk
PERL-DBIX-CONTEXTUALFETCH_IPK=$(BUILD_DIR)/perl-dbix-contextualfetch_$(PERL-DBIX-CONTEXTUALFETCH_VERSION)-$(PERL-DBIX-CONTEXTUALFETCH_IPK_VERSION)_$(TARGET_ARCH).ipk

$(DL_DIR)/$(PERL-DBIX-CONTEXTUALFETCH_SOURCE):
	$(WGET) -P $(DL_DIR) $(PERL-DBIX-CONTEXTUALFETCH_SITE)/$(PERL-DBIX-CONTEXTUALFETCH_SOURCE)

perl-dbix-contextualfetch-source: $(DL_DIR)/$(PERL-DBIX-CONTEXTUALFETCH_SOURCE) $(PERL-DBIX-CONTEXTUALFETCH_PATCHES)

$(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR)/.configured: $(DL_DIR)/$(PERL-DBIX-CONTEXTUALFETCH_SOURCE) $(PERL-DBIX-CONTEXTUALFETCH_PATCHES)
	$(MAKE) perl-dbi-stage
	rm -rf $(BUILD_DIR)/$(PERL-DBIX-CONTEXTUALFETCH_DIR) $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR)
	$(PERL-DBIX-CONTEXTUALFETCH_UNZIP) $(DL_DIR)/$(PERL-DBIX-CONTEXTUALFETCH_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	cat $(PERL-DBIX-CONTEXTUALFETCH_PATCHES) | patch -d $(BUILD_DIR)/$(PERL-DBIX-CONTEXTUALFETCH_DIR) -p1
	mv $(BUILD_DIR)/$(PERL-DBIX-CONTEXTUALFETCH_DIR) $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR)
	(cd $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS)" \
		PERL5LIB="$(STAGING_DIR)/opt/lib/perl5/site_perl" \
		$(PERL_HOSTPERL) Makefile.PL \
		PREFIX=/opt \
	)
	touch $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR)/.configured

perl-dbix-contextualfetch-unpack: $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR)/.configured

$(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR)/.built: $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR)/.configured
	rm -f $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR)/.built
	$(MAKE) -C $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR) \
	PERL5LIB="$(STAGING_DIR)/opt/lib/perl5/site_perl"
	touch $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR)/.built

perl-dbix-contextualfetch: $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR)/.built

$(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR)/.staged: $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR)/.built
	rm -f $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR)/.staged
	$(MAKE) -C $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR) DESTDIR=$(STAGING_DIR) install
	touch $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR)/.staged

perl-dbix-contextualfetch-stage: $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR)/.staged

$(PERL-DBIX-CONTEXTUALFETCH_IPK_DIR)/CONTROL/control:
	@install -d $(PERL-DBIX-CONTEXTUALFETCH_IPK_DIR)/CONTROL
	@rm -f $@
	@echo "Package: perl-dbix-contextualfetch" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PERL-DBIX-CONTEXTUALFETCH_PRIORITY)" >>$@
	@echo "Section: $(PERL-DBIX-CONTEXTUALFETCH_SECTION)" >>$@
	@echo "Version: $(PERL-DBIX-CONTEXTUALFETCH_VERSION)-$(PERL-DBIX-CONTEXTUALFETCH_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PERL-DBIX-CONTEXTUALFETCH_MAINTAINER)" >>$@
	@echo "Source: $(PERL-DBIX-CONTEXTUALFETCH_SITE)/$(PERL-DBIX-CONTEXTUALFETCH_SOURCE)" >>$@
	@echo "Description: $(PERL-DBIX-CONTEXTUALFETCH_DESCRIPTION)" >>$@
	@echo "Depends: $(PERL-DBIX-CONTEXTUALFETCH_DEPENDS)" >>$@
	@echo "Suggests: $(PERL-DBIX-CONTEXTUALFETCH_SUGGESTS)" >>$@
	@echo "Conflicts: $(PERL-DBIX-CONTEXTUALFETCH_CONFLICTS)" >>$@

$(PERL-DBIX-CONTEXTUALFETCH_IPK): $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR)/.built
	rm -rf $(PERL-DBIX-CONTEXTUALFETCH_IPK_DIR) $(BUILD_DIR)/perl-dbix-contextualfetch_*_$(TARGET_ARCH).ipk
	$(MAKE) -C $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR) DESTDIR=$(PERL-DBIX-CONTEXTUALFETCH_IPK_DIR) install
	find $(PERL-DBIX-CONTEXTUALFETCH_IPK_DIR)/opt -name 'perllocal.pod' -exec rm -f {} \;
	(cd $(PERL-DBIX-CONTEXTUALFETCH_IPK_DIR)/opt/lib/perl5 ; \
		find . -name '*.so' -exec chmod +w {} \; ; \
		find . -name '*.so' -exec $(STRIP_COMMAND) {} \; ; \
		find . -name '*.so' -exec chmod -w {} \; ; \
	)
	find $(PERL-DBIX-CONTEXTUALFETCH_IPK_DIR)/opt -type d -exec chmod go+rx {} \;
	$(MAKE) $(PERL-DBIX-CONTEXTUALFETCH_IPK_DIR)/CONTROL/control
	echo $(PERL-DBIX-CONTEXTUALFETCH_CONFFILES) | sed -e 's/ /\n/g' > $(PERL-DBIX-CONTEXTUALFETCH_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PERL-DBIX-CONTEXTUALFETCH_IPK_DIR)

perl-dbix-contextualfetch-ipk: $(PERL-DBIX-CONTEXTUALFETCH_IPK)

perl-dbix-contextualfetch-clean:
	-$(MAKE) -C $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR) clean

perl-dbix-contextualfetch-dirclean:
	rm -rf $(BUILD_DIR)/$(PERL-DBIX-CONTEXTUALFETCH_DIR) $(PERL-DBIX-CONTEXTUALFETCH_BUILD_DIR) $(PERL-DBIX-CONTEXTUALFETCH_IPK_DIR) $(PERL-DBIX-CONTEXTUALFETCH_IPK)
