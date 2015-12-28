#!/bin/perl

# Table Name = graph_templates_item
#
# +------------------------------+-----------------------+------+-----+---------+----------------+
# | Field                        | Type                  | Null | Key | Default | Extra          |
# +------------------------------+-----------------------+------+-----+---------+----------------+
# | id                           | int(12) unsigned      | NO   | PRI | NULL    | auto_increment |
# | hash                         | varchar(32)           | NO   |     |         |                |
# | local_graph_template_item_id | int(12) unsigned      | NO   |     | 0       |                |
# | local_graph_id               | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | graph_template_id            | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | task_item_id                 | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | color_id                     | mediumint(8) unsigned | NO   |     | 0       |                |
# | alpha                        | char(2)               | YES  |     | FF      |                |
# | graph_type_id                | tinyint(3)            | NO   |     | 0       |                |
# | cdef_id                      | mediumint(8) unsigned | NO   |     | 0       |                |
# | consolidation_function_id    | tinyint(2)            | NO   |     | 0       |                |
# | text_format                  | varchar(255)          | YES  |     | NULL    |                |
# | value                        | varchar(255)          | YES  |     | NULL    |                |
# | hard_return                  | char(2)               | YES  |     | NULL    |                |
# | gprint_id                    | mediumint(8) unsigned | NO   |     | 0       |                |
# | sequence                     | mediumint(8) unsigned | NO   |     | 0       |                |
# +------------------------------+-----------------------+------+-----+---------+----------------+

sub delete_table_graph_templates_item {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_w, $sth_w, $arr_w_ref;

	print "***** Delete Table Name = graph_templates_item *****\n";

	$sql_w = "select ref_id from graph_templates_item where ref_hostname = '" . $db_r_host . "';";
	$sth_w = $db_r->prepare($sql_r);
	$sth_w->execute;

	while (my $arr_ref = $sth_w->fetchrow_arrayref) {
		my ($TABLE_ref_id) = @$arr_ref;
print "ref_id = " . $TABLE_ref_id . "\n";

#		$sql_w = "select id from data_template where hash = '" . $TABLE_data_template_hash . "';";
#		$sth_w = $db_w->prepare($sql_w);
#		$sth_w->execute;
#		$arr_w_ref = $sth_w->fetchrow_arrayref;
#		my ($data_template_id) = @$arr_w_ref;
#		$sth_w->finish;

#		$sql_w = "select id from snmp_query where hash = '" . $TABLE_snmp_query_hash . "';";
#		$sth_w = $db_w->prepare($sql_w);
#		$sth_w->execute;
#		$arr_w_ref = $sth_w->fetchrow_arrayref;
#		my ($snmp_query_id) = @$arr_w_ref;
#		$sth_w->finish;

#		# 変換後のhost_idの取得
#		#  変換前 : $TABLE_host_id
#		#  変換後 : $NEW_host_id
#		$sql_w = "select id from host where ref_id = '" . $TABLE_host_id . "' and ref_hostname = '" . $db_r_host . "';";
#		$sth_w = $db_w->prepare($sql_w);
#		$sth_w->execute;
#		$arr_w_ref = $sth_w->fetchrow_arrayref;
#		my ($NEW_host_id) = @$arr_w_ref;
#		$sth_w->finish;

#	        $sql_w = "select count(*) from data_local
#	        where host_id = '" .          $NEW_host_id . "'
#	        and   data_template_id = '" . $data_template_id . "'
#	        and   snmp_query_id = '" .    $snmp_query_id . "'
#	        and   snmp_index = '" .       $TABLE_snmp_index . "'
#	        and   ref_id = '" .           $TABLE_id . "'
#	        and   ref_hostname = '" .     $db_r_host . "';";
#	        $sth_w = $db_w->prepare($sql_w);
#	        $sth_w->execute;
#	        $arr_w_ref = $sth_w->fetchrow_arrayref;
#	        my ($data_local_duplicate) = @$arr_w_ref;
#	        $sth_w->finish;

#	        if($data_local_duplicate == 0) {
#	                $sql_w = "insert into data_local (
#	        		data_template_id,
#	        		host_id,
#	        		snmp_query_id,
#	        		snmp_index,
#	        		ref_id,
#	                        ref_hostname
#	        	) values (
#	        		'" . $data_template_id . "',
#	        		'" . $NEW_host_id . "',
#	        		'" . $snmp_query_id . "',
#	        		'" . $TABLE_snmp_index . "',
#	                        '" . $TABLE_id . "',
#	                        '" . $db_r_host . "'
#	        	);";
#	        	print "SQL(data_local) -> ", $sql_w, "\n";
#	        	$db_w->do($sql_w);
#	        }
#	}
#	$sth_r->finish;
}

1;
