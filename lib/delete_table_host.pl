#!/bin/perl

# Table Name = host
#
# +----------------------+-----------------------+------+-----+---------------------+----------------+
# | Field                | Type                  | Null | Key | Default             | Extra          |
# +----------------------+-----------------------+------+-----+---------------------+----------------+
# | id                   | mediumint(8) unsigned | NO   | PRI | NULL                | auto_increment |
# | host_template_id     | mediumint(8) unsigned | NO   |     | 0                   |                |
# | description          | varchar(150)          | NO   |     |                     |                |
# | hostname             | varchar(250)          | YES  |     | NULL                |                |
# | notes                | text                  | YES  |     | NULL                |                |
# | snmp_community       | varchar(100)          | YES  |     | NULL                |                |
# | snmp_version         | tinyint(1) unsigned   | NO   |     | 1                   |                |
# | snmp_username        | varchar(50)           | YES  |     | NULL                |                |
# | snmp_password        | varchar(50)           | YES  |     | NULL                |                |
# | snmp_auth_protocol   | char(5)               | YES  |     |                     |                |
# | snmp_priv_passphrase | varchar(200)          | YES  |     |                     |                |
# | snmp_priv_protocol   | char(6)               | YES  |     |                     |                |
# | snmp_context         | varchar(64)           | YES  |     |                     |                |
# | snmp_port            | mediumint(5) unsigned | NO   |     | 161                 |                |
# | snmp_timeout         | mediumint(8) unsigned | NO   |     | 500                 |                |
# | availability_method  | smallint(5) unsigned  | NO   |     | 1                   |                |
# | ping_method          | smallint(5) unsigned  | YES  |     | 0                   |                |
# | ping_port            | int(12) unsigned      | YES  |     | 0                   |                |
# | ping_timeout         | int(12) unsigned      | YES  |     | 500                 |                |
# | ping_retries         | int(12) unsigned      | YES  |     | 2                   |                |
# | max_oids             | int(12) unsigned      | YES  |     | 10                  |                |
# | device_threads       | tinyint(2) unsigned   | NO   |     | 1                   |                |
# | disabled             | char(2)               | YES  | MUL | NULL                |                |
# | status               | tinyint(2)            | NO   |     | 0                   |                |
# | status_event_count   | mediumint(8) unsigned | NO   |     | 0                   |                |
# | status_fail_date     | datetime              | NO   |     | 0000-00-00 00:00:00 |                |
# | status_rec_date      | datetime              | NO   |     | 0000-00-00 00:00:00 |                |
# | status_last_error    | varchar(255)          | YES  |     |                     |                |
# | min_time             | decimal(10,5)         | YES  |     | 9.99999             |                |
# | max_time             | decimal(10,5)         | YES  |     | 0.00000             |                |
# | cur_time             | decimal(10,5)         | YES  |     | 0.00000             |                |
# | avg_time             | decimal(10,5)         | YES  |     | 0.00000             |                |
# | total_polls          | int(12) unsigned      | YES  |     | 0                   |                |
# | failed_polls         | int(12) unsigned      | YES  |     | 0                   |                |
# | availability         | decimal(8,5)          | NO   |     | 100.00000           |                |
# +----------------------+-----------------------+------+-----+---------------------+----------------+

sub delete_table_host {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_w, $sth_w, $arr_w_ref;
	my $sql_w2, $sth_w2, $arr_w2_ref;

	print "***** Delete Table Name = host *****\n";

	$sql_w = "select ref_id from host where ref_hostname = '" . $db_r_host . "';";
	$sth_w = $db_w->prepare($sql_w);
	$sth_w->execute;

	while (my $arr_ref = $sth_w->fetchrow_arrayref) {
		my ($TABLE_ref_id) = @$arr_ref;

		$sql_r = "select count(*) from host where id = '" . $TABLE_ref_id . "';";
		$sth_r = $db_r->prepare($sql_r);
		$sth_r->execute;

		$arr_r_ref = $sth_r->fetchrow_arrayref;
		my ($id_exist) = @$arr_r_ref;
		$sth_r->finish;

		if($id_exist < 1) {
			$sql_w2 = "delete from host where ref_id = '" . $TABLE_ref_id . "' and ref_hostname = '" . $db_r_host . "';";
			print "Delete : " . $sql_w . "\n";
	        	$db_w->do($sql_w2);
		}
	}
}

1;
