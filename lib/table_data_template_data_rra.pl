#!/bin/perl

# Table Name = data_template_data_rra
#
# +-----------------------+-----------------------+------+-----+---------+-------+
# | Field                 | Type                  | Null | Key | Default | Extra |
# +-----------------------+-----------------------+------+-----+---------+-------+
# | data_template_data_id | mediumint(8) unsigned | NO   | PRI | 0       |       |
# | rra_id                | mediumint(8) unsigned | NO   | PRI | 0       |       |
# +-----------------------+-----------------------+------+-----+---------+-------+

sub copy_table_data_template_data_rra {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_w, $sth_w, $arr_w_ref;

	print "***** Copy Table Name = data_template_data_rra *****\n";

#	$sql_r = "select
#			data_template_data_id,
#			rra_id
#		from data_template_data_rra;";
	$sql_r = "select
			data_template_data_rra.data_template_data_id,
			rra.hash
		from data_template_data_rra, rra
		where data_template_data_rra.rra_id = rra.id;";
	$sth_r = $db_r->prepare($sql_r);
	$sth_r->execute;

	while (my $arr_ref = $sth_r->fetchrow_arrayref) {
		my (
	                $TABLE_data_template_data_id,
	                $rra_hash
	        ) = @$arr_ref;

		$sql_w = "select id from data_template_data where ref_id = '" . $TABLE_data_template_data_id . "' and ref_hostname = '" . $db_r_host . "';";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute or die $sth_w->errstr;
		$arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($data_template_data_id) = @$arr_w_ref;
		$sth_w->finish;

		$sql_w = "select id from rra where hash = '" . $rra_hash . "';";
		$sth_w = $db_w->prepare($sql_w);
	        $sth_w->execute or die $sth_w->errstr;
	        $arr_w_ref = $sth_w->fetchrow_arrayref;
	        my ($rra_id) = @$arr_w_ref;
	        $sth_w->finish;

		$sql_w = "select count(*) from data_template_data_rra
			where data_template_data_id = '" . $data_template_data_id . "'
			and   rra_id = '" .                $rra_id . "';";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		$arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($data_template_data_rra_duplicate) = @$arr_w_ref;
		$sth_w->finish;

		if($data_template_data_rra_duplicate == 0) {
			$sql_w = "insert into data_template_data_rra (
				data_template_data_id,
				rra_id
			) values (
				'" . $data_template_data_id . "',
				'" . $rra_id . "'
			);";
			print "SQL(data_template_data_rra) -> ", $sql_w, "\n";
			$db_w->do($sql_w);
		}
	}
	$sth_r->finish;
}

1;
