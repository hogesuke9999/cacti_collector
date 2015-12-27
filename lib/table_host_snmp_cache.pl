#!/bin/perl

# Table Name = host_snmp_cache
#
# +---------------+-----------------------+------+-----+---------+-------+
# | Field         | Type                  | Null | Key | Default | Extra |
# +---------------+-----------------------+------+-----+---------+-------+
# | host_id       | mediumint(8) unsigned | NO   | PRI | 0       |       | Table: host - id
# | snmp_query_id | mediumint(8) unsigned | NO   | PRI | 0       |       |
# | field_name    | varchar(50)           | NO   | PRI |         |       |
# | field_value   | varchar(255)          | YES  | MUL | NULL    |       |
# | snmp_index    | varchar(255)          | NO   | PRI |         |       |
# | oid           | text                  | NO   |     | NULL    |       |
# | present       | tinyint(4)            | NO   | MUL | 1       |       |
# +---------------+-----------------------+------+-----+---------+-------+

sub copy_table_host_snmp_cache {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_w, $sth_w, $arr_w_ref;

	print "***** Copy Table Name = host_snmp_cache *****\n";

	$sql_r = "select
			host_id,
			snmp_query_id,
			field_name,
			field_value,
			snmp_index,
			oid,
			present
		from host_snmp_cache;";
	$sth_r = $db_r->prepare($sql_r);
	$sth_r->execute;

	while (my $arr_ref = $sth_r->fetchrow_arrayref) {
		my (
			$TABLE_host_id,
			$TABLE_snmp_query_id,
			$TABLE_field_name,
			$TABLE_field_value,
			$TABLE_snmp_index,
			$TABLE_oid,
			$TABLE_present
		) = @$arr_ref;

	        # 変換後のhost_idの取得
		#  変換前 : $TABLE_host_id
		#  変換後 : $NEW_host_id
		$sql_w = "select id from host where ref_id = '" . $TABLE_host_id . "' and ref_hostname = '" . $db_r_host . "';";
		$sth_w = $db_w->prepare($sql_w);
	 	$sth_w->execute;
		my $arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($NEW_host_id) = @$arr_w_ref;
		$sth_w->finish;

	        $sql_w = "select count(*) from host_snmp_cache
	        where host_id = '" .       $NEW_host_id . "'
	        and   snmp_query_id = '" . $TABLE_snmp_query_id . "'
	        and   field_name = '" .    $TABLE_field_name . "'
	        and   snmp_index = '" .    $TABLE_snmp_index . "';";
		$sth_w = $db_w->prepare($sql_w);
	 	$sth_w->execute;
		$arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($host_snmp_cache_duplicate) = @$arr_w_ref;
		$sth_w->finish;

	        if($host_snmp_cache_duplicate == 0) {
	                $sql_w = "insert into host_snmp_cache (
	        		host_id,
	        		snmp_query_id,
	        		field_name,
	        		field_value,
	        		snmp_index,
	        		oid,
	        		present
	        	) values (
	        		'" . $NEW_host_id . "',
	        		'" . $TABLE_snmp_query_id . "',
	        		'" . $TABLE_field_name . "',
	        		'" . $TABLE_field_value . "',
	        		'" . $TABLE_snmp_index . "',
	        		'" . $TABLE_oid . "',
	        		'" . $TABLE_present . "'
	        	);";
	        	print "SQL(host_snmp_cache):" . $host_snmp_cache_duplicate . " -> ", $sql_w, "\n";
	        	$db_w->do($sql_w);
	        }
	}
	$sth_r->finish;
}

1;
