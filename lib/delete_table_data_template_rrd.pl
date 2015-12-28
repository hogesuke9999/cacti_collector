#!/bin/perl

# Table Name = data_template_data_rra
#
# +-----------------------+-----------------------+------+-----+---------+-------+
# | Field                 | Type                  | Null | Key | Default | Extra |
# +-----------------------+-----------------------+------+-----+---------+-------+
# | data_template_data_id | mediumint(8) unsigned | NO   | PRI | 0       |       |
# | rra_id                | mediumint(8) unsigned | NO   | PRI | 0       |       |
# +-----------------------+-----------------------+------+-----+---------+-------+

sub delete_table_data_template_data_rra {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_w, $sth_w, $arr_w_ref;
	my $sql_w2, $sth_w2, $arr_w2_ref;

	print "***** Delete Table Name = data_template_data_rra *****\n";

	$sql_w = "select ref_id from data_template_data_rra where ref_hostname = '" . $db_r_host . "';";
	$sth_w = $db_w->prepare($sql_w);
	$sth_w->execute;

	while (my $arr_ref = $sth_w->fetchrow_arrayref) {
		my ($TABLE_ref_id) = @$arr_ref;

		$sql_r = "select count(*) from data_template_data_rra where id = '" . $TABLE_ref_id . "';";
		$sth_r = $db_r->prepare($sql_r);
		$sth_r->execute;

		$arr_r_ref = $sth_r->fetchrow_arrayref;
		my ($id_exist) = @$arr_r_ref;
		$sth_r->finish;

		if($id_exist < 1) {
			$sql_w2 = "delete from data_template_data_rra where ref_id = '" . $TABLE_ref_id . "' and ref_hostname = '" . $db_r_host . "';";
			print "Delete : " . $sql_w . "\n";
	        	$db_w->do($sql_w2);
		}
	}
}

1;
