#!/bin/perl


# Table Name = graph_local
#
# +-------------------+-----------------------+------+-----+---------+----------------+
# | Field             | Type                  | Null | Key | Default | Extra          |
# +-------------------+-----------------------+------+-----+---------+----------------+
# | id                | mediumint(8) unsigned | NO   | PRI | NULL    | auto_increment |
# | graph_template_id | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | host_id           | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | snmp_query_id     | mediumint(8)          | NO   | MUL | 0       |                |
# | snmp_index        | varchar(255)          | NO   | MUL |         |                |
# +-------------------+-----------------------+------+-----+---------+----------------+

sub delete_table_graph_local {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_w, $sth_w, $arr_w_ref;
	my $sql_w2, $sth_w2, $arr_w2_ref;

	print "***** Delete Table Name = graph_local *****\n";

	$sql_w = "select ref_id from graph_local where ref_hostname = '" . $db_r_host . "';";
	$sth_w = $db_w->prepare($sql_w);
	$sth_w->execute;

	while (my $arr_ref = $sth_w->fetchrow_arrayref) {
		my ($TABLE_ref_id) = @$arr_ref;

		$sql_r = "select count(*) from graph_local where id = '" . $TABLE_ref_id . "';";
		$sth_r = $db_r->prepare($sql_r);
		$sth_r->execute;

		$arr_r_ref = $sth_r->fetchrow_arrayref;
		my ($id_exist) = @$arr_r_ref;
		$sth_r->finish;

		if($id_exist < 1) {
			$sql_w2 = "delete from graph_local where ref_id = '" . $TABLE_ref_id . "' and ref_hostname = '" . $db_r_host . "';";
			print "Delete : " . $sql_w . "\n";
	        	$db_w->do($sql_w2);
		}
	}
}

1;
