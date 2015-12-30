#!/bin/perl

# Table Name = data_local
#
# +------------------+-----------------------+------+-----+---------+----------------+
# | Field            | Type                  | Null | Key | Default | Extra          |
# +------------------+-----------------------+------+-----+---------+----------------+
# | id               | mediumint(8) unsigned | NO   | PRI | NULL    | auto_increment |
# | data_template_id | mediumint(8) unsigned | NO   |     | 0       |                | Table: data_template - id
# | host_id          | mediumint(8) unsigned | NO   |     | 0       |                | Table: host - id
# | snmp_query_id    | mediumint(8)          | NO   |     | 0       |                |
# | snmp_index       | varchar(255)          | NO   |     |         |                |
# +------------------+-----------------------+------+-----+---------+----------------+

sub copy_table_data_local {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_w, $sth_w, $arr_w_ref;
	my $sql_r2, $sth_r2, $arr_r2_ref;

	print "***** Copy Table Name = data_local *****\n";

	$sql_r = "select
			data_local.id,
			data_template.hash,
			data_local.host_id,
			data_local.snmp_query_id,
			data_local.snmp_index
		from data_local, data_template
		where data_local.data_template_id = data_template.id;";

#	$sql_r = "select
#			data_local.id,
#			data_template.hash,
#			data_local.host_id,
#			snmp_query.hash,
#			data_local.snmp_index
#		from data_local, data_template, snmp_query
#		where data_local.data_template_id = data_template.id
#		and data_local.snmp_query_id = snmp_query.id;";

	$sth_r = $db_r->prepare($sql_r);
	$sth_r->execute;

	while (my $arr_ref = $sth_r->fetchrow_arrayref) {
		my (
			$TABLE_id,
			$TABLE_data_template_hash,
			$TABLE_host_id,
			$TABLE_snmp_query_id,
			$TABLE_snmp_index
		) = @$arr_ref;

print "(data_local:DEBUG)TABLE_id = " .                 $TABLE_id . "\n";
print "(data_local:DEBUG)TABLE_data_template_hash = " . $TABLE_data_template_hash . "\n";
print "(data_local:DEBUG)TABLE_host_id = " .            $TABLE_host_id . "\n";
print "(data_local:DEBUG)TABLE_snmp_query_id = " .      $TABLE_snmp_query_id . "\n";
print "(data_local:DEBUG)TABLE_snmp_index = " .         $TABLE_snmp_index . "\n";

		$sql_w = "select id from data_template where hash = '" . $TABLE_data_template_hash . "';";
print "SQL(data_local:DEBUG) = " . $sql_w . "\n";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		$arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($data_template_id) = @$arr_w_ref;
		$sth_w->finish;

		if($TABLE_snmp_query_id == 0) {
print "data_local : TABLE_snmp_query_id = 0\n";
			my $snmp_query_id = '0';
		} else {
print "data_local : TABLE_snmp_query_id > 0\n";
			$sql_r2 = "select hash from snmp_query where id = '" . $TABLE_snmp_query_id . "';";
			print "SQL(data_local:DEBUG) = " . $sql_r2 . "\n";
			$sth_r2 = $db_r->prepare($sql_r2);
			$sth_r2->execute;
			$arr_r2_ref = $sth_r2->fetchrow_arrayref;
			my ($TABLE_snmp_query_hash) = @$arr_r2_ref;
			$sth_r2->finish;
print "data_local : TABLE_snmp_query_hash = " . $TABLE_snmp_query_hash . "\n";

			$sql_w = "select id from snmp_query where hash = '" . $TABLE_snmp_query_hash . "';";
			print "SQL(data_local:DEBUG) = " . $sql_w . "\n";
			$sth_w = $db_w->prepare($sql_w);
			$sth_w->execute;
			$arr_w_ref = $sth_w->fetchrow_arrayref;
			my ($snmp_query_id) = @$arr_w_ref;
			$sth_w->finish;
print "data_local : snmp_query_id = " . $snmp_query_id . "\n";
		}
print "data_local : snmp_query_id = " . $snmp_query_id . "\n";

		# 変換後のhost_idの取得
		#  変換前 : $TABLE_host_id
		#  変換後 : $NEW_host_id
		$sql_w = "select id from host where ref_id = '" . $TABLE_host_id . "' and ref_hostname = '" . $db_r_host . "';";
print "SQL(data_local:DEBUG) = " . $sql_w . "\n";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		$arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($NEW_host_id) = @$arr_w_ref;
		$sth_w->finish;

	        $sql_w = "select count(*) from data_local
	        where host_id = '" .          $NEW_host_id . "'
	        and   data_template_id = '" . $data_template_id . "'
	        and   snmp_query_id = '" .    $snmp_query_id . "'
	        and   snmp_index = '" .       $TABLE_snmp_index . "'
	        and   ref_id = '" .           $TABLE_id . "'
	        and   ref_hostname = '" .     $db_r_host . "';";
print "SQL(data_local:DEBUG) = " . $sql_w . "\n";
	        $sth_w = $db_w->prepare($sql_w);
	        $sth_w->execute;
	        $arr_w_ref = $sth_w->fetchrow_arrayref;
	        my ($data_local_duplicate) = @$arr_w_ref;
	        $sth_w->finish;

	        if($data_local_duplicate == 0) {
	                $sql_w = "insert into data_local (
	        		data_template_id,
	        		host_id,
	        		snmp_query_id,
	        		snmp_index,
	        		ref_id,
	                        ref_hostname
	        	) values (
	        		'" . $data_template_id . "',
	        		'" . $NEW_host_id . "',
	        		'" . $snmp_query_id . "',
	        		'" . $TABLE_snmp_index . "',
	                        '" . $TABLE_id . "',
	                        '" . $db_r_host . "'
	        	);";
	        	print "SQL(data_local) -> ", $sql_w, "\n";
	        	$db_w->do($sql_w);
	        }
	}
	$sth_r->finish;
}

1;
