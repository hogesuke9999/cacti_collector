#!/bin/perl

# Table Name = data_template_data
#
# +-----------------------------+-----------------------+------+-----+---------+----------------+
# | Field                       | Type                  | Null | Key | Default | Extra          |
# +-----------------------------+-----------------------+------+-----+---------+----------------+
# | id                          | mediumint(8) unsigned | NO   | PRI | NULL    | auto_increment |
# | local_data_template_data_id | mediumint(8) unsigned | NO   |     | 0       |                |
# | local_data_id               | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | data_template_id            | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | data_input_id               | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | t_name                      | char(2)               | YES  |     | NULL    |                |
# | name                        | varchar(250)          | NO   |     |         |                |
# | name_cache                  | varchar(255)          | NO   |     |         |                |
# | data_source_path            | varchar(255)          | YES  |     | NULL    |                |
# | t_active                    | char(2)               | YES  |     | NULL    |                |
# | active                      | char(2)               | YES  |     | NULL    |                |
# | t_rrd_step                  | char(2)               | YES  |     | NULL    |                |
# | rrd_step                    | mediumint(8) unsigned | NO   |     | 0       |                |
# | t_rra_id                    | char(2)               | YES  |     | NULL    |                |
# +-----------------------------+-----------------------+------+-----+---------+----------------+

sub copy_table_data_template_data {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_w, $sth_w, $arr_w_ref;

	print "***** Copy Table Name = data_template_data *****\n";

#	$sql_r = "select
#			id,
#			local_data_template_data_id,
#			local_data_id,
#			data_template_id,
#			data_input_id,
#			name,
#			name_cache,
#			data_source_path,
#			active,
#			rrd_step
#		from data_template_data where not data_source_path is NULL;";

	$sql_r = "select
			data_template_data.id,
			data_template_data.local_data_id,
			data_template_data.data_template_id,
			data_template_data.name,
			data_template_data.name_cache,
			data_template_data.data_source_path,
			data_template_data.active,
			data_template_data.rrd_step,
			data_template.hash,
			data_input.hash
		from data_template_data, data_template, data_input
		where data_template_data.local_data_template_data_id = data_template.id
		and data_template_data.data_input_id = data_input.id;";

	$sth_r = $db_r->prepare($sql_r);
	$sth_r->execute;

	while (my $arr_ref = $sth_r->fetchrow_arrayref) {
		my (
			$TABLE_id,
			$TABLE_local_data_id,
			$TABLE_data_template_id,
			$TABLE_name,
			$TABLE_name_cache,
			$TABLE_data_source_path,
			$TABLE_active,
			$TABLE_rrd_step,
			$TABLE_data_template_hash,
			$TABLE_data_input_hash
		) = @$arr_ref;

		$TABLE_data_source_path =~ s/<path_rra>/<path_rra>\/$db_r_host/;

		$sql_w = "select id from data_template where hash = '" . $TABLE_data_template_hash . "';";
		$sth_w = $db_w->prepare($sql_w);
	        $sth_w->execute;
	        my $arr_w_ref = $sth_w->fetchrow_arrayref;
	        my ($data_template_id) = @$arr_w_ref;
	        $sth_w->finish;

		$sql_w = "select id from data_input where hash = '" . $TABLE_data_input_hash . "';";
		$sth_w = $db_w->prepare($sql_w);
	        $sth_w->execute;
	        my $arr_w_ref = $sth_w->fetchrow_arrayref;
	        my ($data_input_id) = @$arr_w_ref;
	        $sth_w->finish;

		$sql_w = "select id from data_local where ref_id = '" . $TABLE_local_data_id . "' and ref_hostname = '" . $db_r_host . "';";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		my $arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($data_local_id) = @$arr_w_ref;
		$sth_w->finish;

	        $sql_w = "select count(*) from data_template_data
	        where local_data_template_data_id = '" . $data_template_id . "'
	        and   local_data_id = '" .               $data_local_id . "'
	        and   data_template_id = '" .            $data_template_id . "'
	        and   data_input_id = '" .               $data_input_id . "'
	        and   ref_id = '" .                      $TABLE_id . "'
	        and   ref_hostname = '" .                $db_r_host . "';";
	        $sth_w = $db_w->prepare($sql_w);
	        $sth_w->execute;
	        my $arr_w_ref = $sth_w->fetchrow_arrayref;
	        my ($data_template_data_duplicate) = @$arr_w_ref;
	        $sth_w->finish;

		if($data_template_data_duplicate == 0) {
	                $sql_w = "insert into data_template_data (
	        		local_data_template_data_id,
	        		local_data_id,
	        		data_template_id,
	        		data_input_id,
	        		name,
	        		name_cache,
	        		data_source_path,
	        		active,
	        		rrd_step,
	        		ref_id,
	        		ref_hostname
	        	) values (
	        		'" . $data_template_id . "',
	        		'" . $data_local_id . "',
	        		'" . $data_template_id . "',
	        		'" . $data_input_id . "',
	        		'" . $TABLE_name . "',
	        		'" . $TABLE_name_cache . "',
	        		'" . $TABLE_data_source_path . "',
	        		'" . $TABLE_active . "',
	        		'" . $TABLE_rrd_step . "',
	        		'" . $TABLE_id . "',
	        		'" . $db_r_host . "'
	        	);";
	        	print "SQL(data_template_data) -> ", $sql_w, "\n";
	        	$db_w->do($sql_w);
		}
	}
	$sth_r->finish;
}

1;
