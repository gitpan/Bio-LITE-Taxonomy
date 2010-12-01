#!perl -T

use strict;
use warnings;
use Test::More;

BEGIN {
      use_ok ('Bio::LITE::Taxonomy');
}

SKIP: {
      eval { require Bio::LITE::RDP };
      skip "XML::Simple not installed", 12 if $@;

      can_ok ("Bio::LITE::Taxonomy", qw/get_taxonomy get_taxonomy_with_levels get_level_from_name get_taxid_from_name get_taxonomy_from_name/);

      my $datapath = "t/data";

      ok (-e "${datapath}/bergeyTrainingTree.xml","bergeyTrainingTree.xml not present");  # T3
      ok (-r "${datapath}/bergeyTrainingTree.xml","bergeyTrainingTree.xml not readable"); # T4

      my $taxRDP = new_ok ("Bio::LITE::RDP" => ([bergeyXML=>"${datapath}/bergeyTrainingTree.xml"]) );

      my ($tax,@tax);
      eval {
        @tax = $taxRDP->get_taxonomy(22075);
	};
	is($@,"",""); # T6
	ok($#tax == 6, "");                   # T7
	is($tax[0],"Firmicutes", "");       # T8

	eval {
	  $tax = $taxRDP->get_taxonomy(22075);
	  };
	  isa_ok ($tax,"ARRAY");

	  eval {
	    $tax = $taxRDP->get_taxonomy(300000);
	    };
	    ok($tax eq "","");

	    eval {
	      $tax=$taxRDP->get_taxonomy();
	      };
	      ok (!defined $tax);

	      my $level;
	      eval {
	        $level = $taxRDP->get_level_from_name("Bacillaceae 1");
		};
		is($@,"",""); # T7
		is($level,"subfamily",""); # T8
		
}
done_testing();

