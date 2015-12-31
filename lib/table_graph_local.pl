#!/bin/perl

# Table Name = graph_local
#
# +-------------------+-----------------------+------+-----+---------+----------------+
# | Field             | Type                  | Null | Key | Default | Extra          |
# +-------------------+-----------------------+------+-----+---------+----------------+
# | id                | mediumint(8) unsigned | NO   | PRI | NULL    | auto_increment |
# | graph_template_id | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | host_id           | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | snmp_query_id     | mediumint(8)          | NO   | MUL | 0       |                |
# | snmp_index        | varchar(255)          | NO   | MUL |         |                |
# +-------------------+-----------------------+------+-----+---------+----------------+

sub copy_table_graph_local {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_r2, $sth_r2, $arr_r2_ref;
	my $sql_w, $sth_w, $arr_w_ref;
	local $snmp_query_id;

	print "***** Copy Table Name = graph_local *****\n";

#	$sql_r = "select
#			id,
#			graph_template_id,
#			host_id,
#			snmp_query_id,
#			snmp_index
#		from graph_local;";

#	$sql_r = "select
#			graph_local.id,
#			graph_templates.hash,
#			graph_local.host_id,
#			snmp_query.hash,
#			graph_local.snmp_index
#		from graph_local, graph_templates, snmp_query
#		where graph_local.graph_template_id = graph_templates.id
#		  and graph_local.snmp_query_id = snmp_query.id ;";

	$sql_r = "select
			graph_local.id,
			graph_templates.hash,
			graph_local.host_id,
			graph_local.snmp_query_id,
			graph_local.snmp_index
		from graph_local, graph_templates
		where graph_local.graph_template_id = graph_templates.id;";

	$sth_r = $db_r->prepare($sql_r);
	$sth_r->execute;

	while (my $arr_ref = $sth_r->fetchrow_arrayref) {
		my (
			$TABLE_id,
			$TABLE_graph_templates_hash,
			$TABLE_host_id,
			$TABLE_snmp_query_id,
			$TABLE_snmp_index
		) = @$arr_ref;

print "DEBUG:data_graph_local TABLE_id = "                   . $TABLE_id                   . "\n";
print "DEBUG:data_graph_local TABLE_graph_templates_hash = " . $TABLE_graph_templates_hash . "\n";
print "DEBUG:data_graph_local TABLE_host_id = "              . $TABLE_host_id              . "\n";
print "DEBUG:data_graph_local TABLE_snmp_query_id = "        . $TABLE_snmp_query_id        . "\n";
print "DEBUG:data_graph_local TABLE_snmp_index = "           . $TABLE_snmp_index           . "\n";

		# 変換後のhost_idの取得
		#  変換前 : $TABLE_host_id
		#  変換後 : $NEW_host_id
		$sql_w = "select id from host where ref_id = '" . $TABLE_host_id . "' and ref_hostname = '" . $db_r_host . "';";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		my $arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($NEW_host_id) = @$arr_w_ref;
		$sth_w->finish;

		$sql_w = "select id from graph_templates where hash = '';";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		my $arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($graph_template_id) = @$arr_w_ref;
		$sth_w->finish;

		if($TABLE_snmp_query_id == 0) {
			$snmp_query_id = 0;
		} else {
			$sql_r2 = "select hash from snmp_query where id = '" . $TABLE_snmp_query_id . "';";
			$sth_r2 = $db_r->prepare($sql_r2);
			$sth_r2->execute;
			$arr_r2_ref = $sth_r2->fetchrow_arrayref;
			($TABLE_snmp_query_hash) = @$arr_r2_ref;
			$sth_r2->finish;

			$sql_w = "select id from snmp_query where hash = '" . $TABLE_snmp_query_hash . "';";
			$sth_w = $db_w->prepare($sql_w);
			$sth_w->execute;
			my $arr_w_ref = $sth_w->fetchrow_arrayref;
			my ($snmp_query_id) = @$arr_w_ref;
			$sth_w->finish;
		}

print "DEBUG:data_graph_local snmp_query_id = " . $snmp_query_id . "\n";

	        $sql_w = "select count(*) from graph_local
	        where host_id = '" .           $NEW_host_id . "'
	        and   graph_template_id = '" . $graph_template_id . "'
	        and   snmp_query_id = '" .     $snmp_query_id . "'
	        and   snmp_index = '" .        $TABLE_snmp_index . "'
	        and   ref_id = '" .            $TABLE_id . "'
	        and   ref_hostname = '" .      $db_r_host . "';";
	        $sth_w = $db_w->prepare($sql_w);
	        $sth_w->execute;
	        $arr_w_ref = $sth_w->fetchrow_arrayref;
	        my ($graph_local_duplicate) = @$arr_w_ref;
	        $sth_w->finish;

	        if($graph_local_duplicate == 0) {
	                $sql_w = "insert into graph_local (
	        		graph_template_id,
	        		host_id,
	        		snmp_query_id,
	        		snmp_index,
	        		ref_id,
	        		ref_hostname
	        	) values (
	        		'" . $graph_template_id . "',
	        		'" . $NEW_host_id . "',
	        		'" . $snmp_query_id . "',
	        		'" . $TABLE_snmp_index . "',
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
