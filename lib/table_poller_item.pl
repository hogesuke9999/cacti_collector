#!/bin/perl

# Table Name = poller_item
#
# +----------------------+-----------------------+------+-----+---------+-------+
# | Field                | Type                  | Null | Key | Default | Extra |
# +----------------------+-----------------------+------+-----+---------+-------+
# | local_data_id        | mediumint(8) unsigned | NO   | PRI | 0       |       |
# | poller_id            | smallint(5) unsigned  | NO   |     | 0       |       |
# | host_id              | mediumint(8) unsigned | NO   | MUL | 0       |       |
# | action               | tinyint(2) unsigned   | NO   | MUL | 1       |       |
# | present              | tinyint(4)            | NO   | MUL | 1       |       |
# | hostname             | varchar(250)          | NO   |     |         |       |
# | snmp_community       | varchar(100)          | NO   |     |         |       |
# | snmp_version         | tinyint(1) unsigned   | NO   |     | 0       |       |
# | snmp_username        | varchar(50)           | NO   |     |         |       |
# | snmp_password        | varchar(50)           | NO   |     |         |       |
# | snmp_auth_protocol   | varchar(5)            | NO   |     |         |       |
# | snmp_priv_passphrase | varchar(200)          | NO   |     |         |       |
# | snmp_priv_protocol   | varchar(6)            | NO   |     |         |       |
# | snmp_context         | varchar(64)           | YES  |     |         |       |
# | snmp_port            | mediumint(5) unsigned | NO   |     | 161     |       |
# | snmp_timeout         | mediumint(8) unsigned | NO   |     | 0       |       |
# | rrd_name             | varchar(19)           | NO   | PRI |         |       |
# | rrd_path             | varchar(255)          | NO   |     |         |       |
# | rrd_num              | tinyint(2) unsigned   | NO   |     | 0       |       |
# | rrd_step             | mediumint(8)          | NO   |     | 300     |       |
# | rrd_next_step        | mediumint(8)          | NO   | MUL | 0       |       |
# | arg1                 | text                  | YES  |     | NULL    |       |
# | arg2                 | varchar(255)          | YES  |     | NULL    |       |
# | arg3                 | varchar(255)          | YES  |     | NULL    |       |
# +----------------------+-----------------------+------+-----+---------+-------+

sub copy_table_poller_item {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_w, $sth_w, $arr_w_ref;

	print "***** Copy Table Name = poller_item *****\n";

	$sql_r = "select
			local_data_id,
			poller_id,
			host_id,
			action,
			present,
			hostname,
			snmp_community,
			snmp_version,
			snmp_username,
			snmp_password,
			snmp_auth_protocol,
			snmp_priv_passphrase,
			snmp_priv_protocol,
			snmp_context,
			snmp_port,
			snmp_timeout,
			rrd_name,
			rrd_path,
			rrd_num,
			rrd_step,
			rrd_next_step,
			arg1,
			arg2,
			arg3
	from poller_item;";

	$sth_r = $db_r->prepare($sql_r);
	$sth_r->execute;

	while (my $arr_ref = $sth_r->fetchrow_arrayref) {
		my (
			$TABLE_local_data_id,
			$TABLE_poller_id,
			$TABLE_host_id,
			$TABLE_action,
			$TABLE_present,
			$TABLE_hostname,
			$TABLE_snmp_community,
			$TABLE_snmp_version,
			$TABLE_snmp_username,
			$TABLE_snmp_password,
			$TABLE_snmp_auth_protocol,
			$TABLE_snmp_priv_passphrase,
			$TABLE_snmp_priv_protocol,
			$TABLE_snmp_context,
			$TABLE_snmp_port,
			$TABLE_snmp_timeout,
			$TABLE_rrd_name,
			$TABLE_rrd_path,
			$TABLE_rrd_num,
			$TABLE_rrd_step,
			$TABLE_rrd_next_step,
			$TABLE_arg1,
			$TABLE_arg2,
			$TABLE_arg3
		) = @$arr_ref;

		$sql_w = "select id from data_local where ref_id = '" . $TABLE_local_data_id . "' and ref_hostname = '" . $db_r_host . "'";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		my $arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($local_data_id) = @$arr_w_ref;
		$sth_w->finish;

		$sql_w = "select id from host where ref_id = '" . $TABLE_host_id . "' and ref_hostname = '" . $db_r_host . "'";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		my $arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($host_id) = @$arr_w_ref;
		$sth_w->finish;

		$sql_w = "select count(*) from poller_item where local_data_id = '" . $local_data_id . "' and rrd_name = '" . $TABLE_rrd_name . "';";
		$sth_w = $db_w->prepare($sql_w);
	 	$sth_w->execute;
		my $arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($poller_item_duplicate) = @$arr_w_ref;
		$sth_w->finish;

		if($poller_item_duplicate == 0) {
			$sql_w = "insert into poller_item (
				local_data_id,
				poller_id,
				host_id,
				action,
				present,
				hostname,
				snmp_community,
				snmp_version,
				snmp_username,
				snmp_password,
				snmp_auth_protocol,
				snmp_priv_passphrase,
				snmp_priv_protocol,
				snmp_context,
				snmp_port,
				snmp_timeout,
				rrd_name,
				rrd_path,
				rrd_num,
				rrd_step,
				rrd_next_step,
				arg1,
				arg2,
				arg3
			) values (
				'" . $local_data_id . "',
				'" . $TABLE_poller_id . "',
				'" . $host_id . "',
				'" . $TABLE_action . "',
				'" . $TABLE_present . "',
				'" . $TABLE_hostname . "',
				'" . $TABLE_snmp_community . "',
				'" . $TABLE_snmp_version . "',
				'" . $TABLE_snmp_username . "',
				'" . $TABLE_snmp_password . "',
				'" . $TABLE_snmp_auth_protocol . "',
				'" . $TABLE_snmp_priv_passphrase . "',
				'" . $TABLE_snmp_priv_protocol . "',
				'" . $TABLE_snmp_context . "',
				'" . $TABLE_snmp_port . "',
				'" . $TABLE_snmp_timeout . "',
				'" . $TABLE_rrd_name . "',
				'" . $TABLE_rrd_path . "',
				'" . $TABLE_rrd_num . "',
				'" . $TABLE_rrd_step . "',
				'" . $TABLE_rrd_next_step . "',
				'" . $TABLE_arg1 . "',
				'" . $TABLE_arg2 . "',
				'" . $TABLE_arg3 . "'
			);";
			print "SQL(poller_item) -> ", $sql_w, "\n";
			$db_w->do($sql_w);
		}
	}
	$sth_r->finish;
}

1;
