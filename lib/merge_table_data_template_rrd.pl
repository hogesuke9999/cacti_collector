#!/bin/perl

# Table Name = data_template_rrd
#
# +----------------------------+-----------------------+------+-----+---------+----------------+
# | Field                      | Type                  | Null | Key | Default | Extra          |
# +----------------------------+-----------------------+------+-----+---------+----------------+
# | id                         | mediumint(8) unsigned | NO   | PRI | NULL    | auto_increment |
# | hash                       | varchar(32)           | NO   |     |         |                |
# | local_data_template_rrd_id | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | local_data_id              | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | data_template_id           | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | t_rrd_maximum              | char(2)               | YES  |     | NULL    |                |
# | rrd_maximum                | varchar(20)           | NO   |     | 0       |                |
# | t_rrd_minimum              | char(2)               | YES  |     | NULL    |                |
# | rrd_minimum                | varchar(20)           | NO   |     | 0       |                |
# | t_rrd_heartbeat            | char(2)               | YES  |     | NULL    |                |
# | rrd_heartbeat              | mediumint(6)          | NO   |     | 0       |                |
# | t_data_source_type_id      | char(2)               | YES  |     | NULL    |                |
# | data_source_type_id        | smallint(5)           | NO   |     | 0       |                |
# | t_data_source_name         | char(2)               | YES  |     | NULL    |                |
# | data_source_name           | varchar(19)           | NO   |     |         |                |
# | t_data_input_field_id      | char(2)               | YES  |     | NULL    |                |
# | data_input_field_id        | mediumint(8) unsigned | NO   |     | 0       |                |
# +----------------------------+-----------------------+------+-----+---------+----------------+

sub merge_table_data_template_rrd {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_w, $sth_w, $arr_w_ref;

	print "***** Merge Table Name = data_template_rrd *****\n";

	$sql_r = "select
			id,
			hash,
			local_data_template_rrd_id,
			local_data_id,
			data_template_id,
			rrd_maximum,
			rrd_minimum,
			rrd_heartbeat,
			data_source_type_id,
			data_source_name,
			data_input_field_id
 		from data_template_rrd where not hash = '' ;";
	$sth_r = $db_r->prepare($sql_r);
	$sth_r->execute;

	while (my $arr_ref = $sth_r->fetchrow_arrayref) {
		my (
			$TABLE_id,
			$TABLE_hash,
			$TABLE_local_data_template_rrd_id,
			$TABLE_local_data_id,
			$TABLE_data_template_id,
			$TABLE_rrd_maximum,
			$TABLE_rrd_minimum,
			$TABLE_rrd_heartbeat,
			$TABLE_data_source_type_id,
			$TABLE_data_source_name,
			$TABLE_data_input_field_id
		) = @$arr_ref;

		$sql_w = "select count(*) from data_template_rrd where hash = '" . $TABLE_hash . "' ;";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		$arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($data_template_rrd_hash_duplicate) = @$arr_w_ref;
		$sth_w->finish;

	        if($data_template_rrd_duplicate == 0) {
			$sql_w = "insert into data_template_rrd (
					hash,
					local_data_template_rrd_id,
					local_data_id,
					data_template_id,
					rrd_maximum,
					rrd_minimum,
					rrd_heartbeat,
					data_source_type_id,
					data_source_name,
					data_input_field_id,
					ref_id,
		        		ref_hostname
	        	) values (
				'" . $TABLE_hash . "',
				'" . $TABLE_local_data_template_rrd_id . "',
				'" . $TABLE_local_data_id . "',
				'" . $TABLE_data_template_id . "',
				'" . $TABLE_rrd_maximum . "',
				'" . $TABLE_rrd_minimum . "',
				'" . $TABLE_rrd_heartbeat . "',
				'" . $TABLE_data_source_type_id . "',
				'" . aa$TABLE_data_source_namea . "',
				'" . $TABLE_data_input_field_id . "',
	        		'" . $TABLE_id . "',
	        		'" . $db_r_host . "'
	        	);";
	        	print "SQL -> ", $sql_w, "\n";
	        	$db_w->do($sql_w);
	        }
	}
	$sth_r->finish;
}

1;
