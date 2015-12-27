#!/bin/perl

# Table Name = poller_reindex
#
# +---------------+-----------------------+------+-----+---------+-------+
# | Field         | Type                  | Null | Key | Default | Extra |
# +---------------+-----------------------+------+-----+---------+-------+
# | host_id       | mediumint(8) unsigned | NO   | PRI | 0       |       | Table: host - id
# | data_query_id | mediumint(8) unsigned | NO   | PRI | 0       |       |
# | action        | tinyint(3) unsigned   | NO   |     | 0       |       |
# | present       | tinyint(4)            | NO   | MUL | 1       |       |
# | op            | char(1)               | NO   |     |         |       |
# | assert_value  | varchar(100)          | NO   |     |         |       |
# | arg1          | varchar(255)          | NO   | PRI |         |       |
# +---------------+-----------------------+------+-----+---------+-------+

sub copy_table_poller_reindex {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_w, $sth_w, $arr_w_ref;

	print "***** Copy Table Name = poller_reindex *****\n";

	$sql_r = "select
			host_id,
			data_query_id,
			action,
			present,
			op,
			assert_value,
			arg1
		from poller_reindex;";
	$sth_r = $db_r->prepare($sql_r);
	$sth_r->execute;

	while (my $arr_ref = $sth_r->fetchrow_arrayref) {
		my (
			$TABLE_host_id,
			$TABLE_data_query_id,
			$TABLE_action,
			$TABLE_present,
			$TABLE_op,
			$TABLE_assert_value,
			$TABLE_arg1
		) = @$arr_ref;

	        # 変換後のhost_idの取得
		#  変換前 : $TABLE_host_id
		#  変換後 : $NEW_host_id
		$sql_w = "select id from host where ref_id = '" . $TABLE_host_id . "' and ref_hostname = '" . $db_r_host . "';";
		$sth_w = $db_w->prepare($sql_w);
	 	$sth_w->execute;
		$arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($NEW_host_id) = @$arr_w_ref;
		$sth_w->finish;

	        $sql_w = "select count(*) from poller_reindex
	        where host_id = '" .       $NEW_host_id . "'
	        and   data_query_id = '" . $TABLE_data_query_id . "'
	        and   arg1 = '" .          $TABLE_arg1 . "';";
	        $sth_w = $db_w->prepare($sql_w);
	        $sth_w->execute;
	        $arr_w_ref = $sth_w->fetchrow_arrayref;
	        my ($poller_reindex_duplicate) = @$arr_w_ref;
	        $sth_w->finish;

	        if($poller_reindex_duplicate == 0) {
	                $sql_w = "insert into poller_reindex (
	        		host_id,
	        		data_query_id,
	        		action,
	        		present,
	        		op,
	        		assert_value,
	        		arg1
	        	) values (
	        		'" . $NEW_host_id . "',
	        		'" . $TABLE_data_query_id . "',
	        		'" . $TABLE_action . "',
	        		'" . $TABLE_present . "',
	        		'" . $TABLE_op . "',
	        		'" . $TABLE_assert_value . "',
	        		'" . $TABLE_arg1 . "'
	        	);";
	        	print "SQL(poller_reindex) -> ", $sql_w, "\n";
	        	$db_w->do($sql_w);
	        }
	}
	$sth_r->finish;
}

1;
