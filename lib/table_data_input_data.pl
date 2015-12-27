#!/bin/perl

# Table Name = data_input_data
#
# +-----------------------+-----------------------+------+-----+---------+-------+
# | Field                 | Type                  | Null | Key | Default | Extra |
# +-----------------------+-----------------------+------+-----+---------+-------+
# | data_input_field_id   | mediumint(8) unsigned | NO   | PRI | 0       |       |
# | data_template_data_id | mediumint(8) unsigned | NO   | PRI | 0       |       |
# | t_value               | char(2)               | YES  | MUL | NULL    |       |
# | value                 | text                  | YES  |     | NULL    |       |
# +-----------------------+-----------------------+------+-----+---------+-------+

sub copy_table_data_input_data {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_w, $sth_w, $arr_w_ref;

	print "***** Copy Table Name = data_input_data *****\n";

#	$sql_r = "select
#			data_input_field_id,
#			data_template_data_id,
#			value
#		from data_input_data;";

	$sql_r = "select
			data_input_fields.hash,
			data_template_data_id,
			value
		from data_input_data, data_input_fields
		where data_input_data.data_input_field_id = data_input_fields.id;";

	$sth_r = $db_r->prepare($sql_r);
	$sth_r->execute;

	while (my $arr_ref = $sth_r->fetchrow_arrayref) {
		my (
			$data_input_fields_hash,
			$TABLE_data_template_data_id,
			$TABLE_value
		) = @$arr_ref;

		$sql_w = "select id from data_input_fields where hash = '" . $data_input_fields_hash . "';";
		$sth_w = $db_w->prepare($sql_w);
	 	$sth_w->execute;
		my $arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($data_input_field_id) = @$arr_w_ref;
		$sth_w->finish;

		$sql_w = "select id from data_template_data where ref_id = '" . $TABLE_data_template_data_id . "' and ref_hostname = '" . $db_r_host . "'";
		$sth_w = $db_w->prepare($sql_w);
	 	$sth_w->execute;
		my $arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($data_template_data_id) = @$arr_w_ref;
		$sth_w->finish;

		$sql_w = "select count(*) from data_input_data where data_input_field_id = '" . $data_input_field_id . "' and data_template_data_id = '" . $data_template_data_id . "';";
		$sth_w = $db_w->prepare($sql_w);
	 	$sth_w->execute;
		my $arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($COUNT) = @$arr_w_ref;
		$sth_w->finish;

		if($COUNT == 0) {
			$sql_w = "insert into data_input_data (
				data_input_field_id,
				data_template_data_id,
				value
			) values (
				'" . $data_input_field_id . "',
				'" . $data_template_data_id . "',
				'" . $TABLE_value . "'
			);";
		} else {
			$sql_w = "update data_input_data set value = '" . $TABLE_value . "' where data_input_field_id = '" . $data_input_field_id . "' and data_template_data_id = '" . $data_template_data_id . "';";
		}
		print "SQL(data_input_data) -> ", $sql_w, "\n";
		$db_w->do($sql_w);
	}
	$sth_r->finish;
}

1;
