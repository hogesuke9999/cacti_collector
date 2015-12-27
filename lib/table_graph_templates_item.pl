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

sub copy_table_graph_templates_item {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_w, $sth_w, $arr_w_ref;

	print "***** Copy Table Name = graph_templates_item *****\n";

#	$sql_r = "select
#			id,
#			hash,
#			local_graph_template_item_id,
#			local_graph_id,
#			graph_template_id,
#			task_item_id,
#			color_id, alpha,
#			graph_type_id,
#			cdef_id,
#			consolidation_function_id,
#			text_format,
#			value,
#			hard_return,
#			gprint_id,
#			sequence
#		from graph_templates_item;";

	$sql_r = "select
			graph_templates_item_1.id,
			graph_templates_item_2.hash,
			graph_templates_item_1.local_graph_id,
			graph_templates_item_1.graph_template_id,
			graph_templates_item_1.task_item_id,
			graph_templates_item_1.color_id,
			graph_templates_item_1.alpha,
			graph_templates_item_1.graph_type_id,
			graph_templates_item_1.cdef_id,
			graph_templates_item_1.consolidation_function_id,
			graph_templates_item_1.text_format,
			graph_templates_item_1.value,
			graph_templates_item_1.hard_return,
			graph_templates_item_1.gprint_id,
			graph_templates_item_1.sequence
		from graph_templates_item graph_templates_item_1,
		     graph_templates_item graph_templates_item_2
		where graph_templates_item_1.hash = ''
		  and graph_templates_item_1.local_graph_template_item_id = graph_templates_item_2.id
		;";

	$sth_r = $db_r->prepare($sql_r);
	$sth_r->execute;

	while (my $arr_ref = $sth_r->fetchrow_arrayref) {
		my (
			$TABLE_id,
			$TABLE_hash,
			$TABLE_local_graph_id,
			$TABLE_graph_template_id,
			$TABLE_task_item_id,
			$TABLE_color_id,
			$TABLE_alpha,
			$TABLE_graph_type_id,
			$TABLE_cdef_id,
			$TABLE_consolidation_function_id,
			$TABLE_text_format,
			$TABLE_value,
			$TABLE_hard_return,
			$TABLE_gprint_id,
			$TABLE_sequence
		) = @$arr_ref;

		$sql_w = "select id from graph_templates_item where hash = '" . $TABLE_hash . "';";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		$arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($local_graph_template_item_id) = @$arr_w_ref;
		$sth_w->finish;

		$sql_w = "select id from graph_local where ref_id = '" . $TABLE_local_graph_id . "' and ref_hostname = '" . $db_r_host . "';";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		$arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($local_graph_id) = @$arr_w_ref;
		$sth_w->finish;

		$sql_w = "select id from data_template_rrd where ref_id = '" . $TABLE_task_item_id . "' and ref_hostname = '" . $db_r_host . "';";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		$arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($task_item_id) = @$arr_w_ref;
		$sth_w->finish;


	        $sql_w = "select count(*) from graph_templates_item
	        where local_graph_template_item_id = '" . $local_graph_template_item_id . "'
	        and   local_graph_id = '" .               $local_graph_id . "'
	        and   graph_template_id = '" .            $TABLE_graph_template_id . "'
	        and   task_item_id = '" .                 $task_item_id . "'
	        and   graph_type_id = '" .                $TABLE_graph_type_id . "'
	        and   sequence = '" .                     $TABLE_sequence . "'
	        and   ref_id = '" .                       $TABLE_id . "'
	        and   ref_hostname = '" .                 $db_r_host . "';";
	        $sth_w = $db_w->prepare($sql_w);
	        $sth_w->execute;
	        $arr_w_ref = $sth_w->fetchrow_arrayref;
	        my ($graph_templates_item_duplicate) = @$arr_w_ref;
	        $sth_w->finish;

	        if($graph_templates_item_duplicate == 0) {
	                $sql_w = "insert into graph_templates_item (
	        		hash,
	        		local_graph_template_item_id,
	        		local_graph_id,
	        		graph_template_id,
	        		task_item_id,
	        		color_id,
	        		alpha,
	        		graph_type_id,
	        		cdef_id,
	        		consolidation_function_id,
	        		text_format,
	        		value,
	        		hard_return,
	        		gprint_id,
	        		sequence,
	                        ref_id,
	                        ref_hostname
	        	) values (
	        		'" . $TABLE_hash . "',
	        		'" . $local_graph_template_item_id . "',
	        		'" . $local_graph_id . "',
	        		'" . $TABLE_graph_template_id . "',
	        		'" . $task_item_id . "',
	        		'" . $TABLE_color_id . "',
	        		'" . $TABLE_alpha . "',
	        		'" . $TABLE_graph_type_id . "',
	        		'" . $TABLE_cdef_id . "',
	        		'" . $TABLE_consolidation_function_id . "',
	        		'" . $TABLE_text_format . "',
	        		'" . $TABLE_value . "',
	        		'" . $TABLE_hard_return . "',
	        		'" . $TABLE_gprint_id . "',
	        		'" . $TABLE_sequence . "',
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
