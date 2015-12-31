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

sub copy_table_data_template_rrd {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_w, $sth_w, $arr_w_ref;

	print "***** Copy Table Name = data_template_rrd *****\n";

	$sql_r = "select
			data_template_rrd_1.id,
			data_template_rrd_2.hash,
			data_template_rrd_1.local_data_id,
			data_template.hash,
			data_template_rrd_1.data_template_id,
			data_template_rrd_1.rrd_maximum,
			data_template_rrd_1.rrd_minimum,
			data_template_rrd_1.rrd_heartbeat,
			data_template_rrd_1.data_source_type_id,
			data_template_rrd_1.data_source_name,
			data_template_rrd_1.data_input_field_id
		from data_template_rrd data_template_rrd_1,
		     data_template_rrd data_template_rrd_2,
		     data_template data_template
		where data_template_rrd_1.hash = ''
		  and data_template_rrd_1.local_data_template_rrd_id = data_template_rrd_2.id
		  and data_template_rrd_1.data_template_id = data_template.id ;";

	$sth_r = $db_r->prepare($sql_r);
	$sth_r->execute;

	while (my $arr_ref = $sth_r->fetchrow_arrayref) {
		my (
			$TABLE_id,
			$TABLE_hash,
			$TABLE_local_data_id,
			$data_template_hash,
			$TABLE_data_template_id,
			$TABLE_rrd_maximum,
			$TABLE_rrd_minimum,
			$TABLE_rrd_heartbeat,
			$TABLE_data_source_type_id,
			$TABLE_data_source_name,
			$TABLE_data_input_field_id
		) = @$arr_ref;

print "DEBUG:data_template_rrd TABLE_id = " .                  $TABLE_id                  . "\n";
print "DEBUG:data_template_rrd TABLE_hash = " .                $TABLE_hash                . "\n";
print "DEBUG:data_template_rrd TABLE_local_data_id = " .       $TABLE_local_data_id       . "\n";
print "DEBUG:data_template_rrd data_template_hash = " .        $data_template_hash        . "\n";
print "DEBUG:data_template_rrd TABLE_data_template_id = " .    $TABLE_data_template_id    . "\n";
print "DEBUG:data_template_rrd TABLE_rrd_maximum = " .         $TABLE_rrd_maximum         . "\n";
print "DEBUG:data_template_rrd TABLE_rrd_minimum = " .         $TABLE_rrd_minimum         . "\n";
print "DEBUG:data_template_rrd TABLE_rrd_heartbeat = " .       $TABLE_rrd_heartbeat       . "\n";
print "DEBUG:data_template_rrd TABLE_data_source_type_id = " . $TABLE_data_source_type_id . "\n";
print "DEBUG:data_template_rrd TABLE_data_source_name = " .    $TABLE_data_source_name    . "\n";
print "DEBUG:data_template_rrd TABLE_data_input_field_id = " . $TABLE_data_input_field_id . "\n";

		$sql_w = "select id from data_template_rrd where hash = '" . $TABLE_hash . "';";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		$arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($local_data_template_rrd_id) = @$arr_w_ref;
		$sth_w->finish;

		$sql_w = "select id from data_template where hash = '" . $data_template_hash . "';";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		$arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($data_template_id) = @$arr_w_ref;
		$sth_w->finish;

		$sql_w = "select id from data_local where ref_id = '" . $TABLE_local_data_id . "' and ref_hostname = '" . $db_r_host . "';";
		print "SQL(data_template_rrd:DEBUG) = " . $sql_w . "\n";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		$arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($local_data_id) = @$arr_w_ref;
		$sth_w->finish;

		$sql_w = "select count(*) from data_template_rrd
		where local_data_template_rrd_id = '" . $local_data_template_rrd_id . "'
		and   local_data_id = '" .              $local_data_id . "'
		and   data_template_id = '" .           $data_template_id . "'
		and   ref_id = '" .                     $TABLE_id . "'
		and   ref_hostname = '" .               $db_r_host . "';";

	        $sth_w = $db_w->prepare($sql_w);
	        $sth_w->execute;
	        $arr_w_ref = $sth_w->fetchrow_arrayref;
	        my ($data_template_rrd_duplicate) = @$arr_w_ref;
	        $sth_w->finish;
# print "SQL = " . $sql_w . "\n";
print "$data_template_rrd_duplicate = " . $data_template_rrd_duplicate . "\n";
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
	        		'" . $local_data_template_rrd_id . "',
	        		'" . $local_data_id . "',
	        		'" . $data_template_id . "',
	        		'" . $TABLE_rrd_maximum . "',
	        		'" . $TABLE_rrd_minimum . "',
	        		'" . $TABLE_rrd_heartbeat . "',
	        		'" . $TABLE_data_source_type_id . "',
	        		'" . $TABLE_data_source_name . "',
	        		'" . $TABLE_data_input_field_id . "',
	        		'" . $TABLE_id . "',
	        		'" . $db_r_host . "'
	        	);";
	        	print "SQL -> ", $sql_w, "\n";
	        	$db_w->do($sql_w);
		} else {
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
				'" . $local_data_template_rrd_id . "',
				'" . $local_data_id . "',
				'" . $data_template_id . "',
				'" . $TABLE_rrd_maximum . "',
				'" . $TABLE_rrd_minimum . "',
				'" . $TABLE_rrd_heartbeat . "',
				'" . $TABLE_data_source_type_id . "',
				'" . $TABLE_data_source_name . "',
				'" . $TABLE_data_input_field_id . "',
				'" . $TABLE_id . "',
				'" . $db_r_host . "'
			);";
			print "SQL -> ", $sql_w, "\n";
	        }
	}
	$sth_r->finish;
}

1;
