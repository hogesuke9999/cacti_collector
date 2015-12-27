#!/bin/perl

# Table Name = graph_templates_graph
#
# +-------------------------------+-----------------------+------+-----+---------+----------------+
# | Field                         | Type                  | Null | Key | Default | Extra          |
# +-------------------------------+-----------------------+------+-----+---------+----------------+
# | id                            | mediumint(8) unsigned | NO   | PRI | NULL    | auto_increment |
# | local_graph_template_graph_id | mediumint(8) unsigned | NO   |     | 0       |                |
# | local_graph_id                | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | graph_template_id             | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | t_image_format_id             | char(2)               | YES  |     | 0       |                |
# | image_format_id               | tinyint(1)            | NO   |     | 0       |                |
# | t_title                       | char(2)               | YES  |     | 0       |                |
# | title                         | varchar(255)          | NO   |     |         |                |
# | title_cache                   | varchar(255)          | NO   | MUL |         |                |
# | t_height                      | char(2)               | YES  |     | 0       |                |
# | height                        | mediumint(8)          | NO   |     | 0       |                |
# | t_width                       | char(2)               | YES  |     | 0       |                |
# | width                         | mediumint(8)          | NO   |     | 0       |                |
# | t_upper_limit                 | char(2)               | YES  |     | 0       |                |
# | upper_limit                   | varchar(20)           | NO   |     | 0       |                |
# | t_lower_limit                 | char(2)               | YES  |     | 0       |                |
# | lower_limit                   | varchar(20)           | NO   |     | 0       |                |
# | t_vertical_label              | char(2)               | YES  |     | 0       |                |
# | vertical_label                | varchar(200)          | YES  |     | NULL    |                |
# | t_slope_mode                  | char(2)               | YES  |     | 0       |                |
# | slope_mode                    | char(2)               | YES  |     | on      |                |
# | t_auto_scale                  | char(2)               | YES  |     | 0       |                |
# | auto_scale                    | char(2)               | YES  |     | NULL    |                |
# | t_auto_scale_opts             | char(2)               | YES  |     | 0       |                |
# | auto_scale_opts               | tinyint(1)            | NO   |     | 0       |                |
# | t_auto_scale_log              | char(2)               | YES  |     | 0       |                |
# | auto_scale_log                | char(2)               | YES  |     | NULL    |                |
# | t_scale_log_units             | char(2)               | YES  |     | 0       |                |
# | scale_log_units               | char(2)               | YES  |     | NULL    |                |
# | t_auto_scale_rigid            | char(2)               | YES  |     | 0       |                |
# | auto_scale_rigid              | char(2)               | YES  |     | NULL    |                |
# | t_auto_padding                | char(2)               | YES  |     | 0       |                |
# | auto_padding                  | char(2)               | YES  |     | NULL    |                |
# | t_base_value                  | char(2)               | YES  |     | 0       |                |
# | base_value                    | mediumint(8)          | NO   |     | 0       |                |
# | t_grouping                    | char(2)               | YES  |     | 0       |                |
# | grouping                      | char(2)               | NO   |     |         |                |
# | t_export                      | char(2)               | YES  |     | 0       |                |
# | export                        | char(2)               | YES  |     | NULL    |                |
# | t_unit_value                  | char(2)               | YES  |     | 0       |                |
# | unit_value                    | varchar(20)           | YES  |     | NULL    |                |
# | t_unit_exponent_value         | char(2)               | YES  |     | 0       |                |
# | unit_exponent_value           | varchar(5)            | NO   |     |         |                |
# +-------------------------------+-----------------------+------+-----+---------+----------------+

sub copy_table_graph_templates_graph {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_w, $sth_w, $arr_w_ref;

	print "***** Copy Table Name = graph_templates_graph *****\n";

#	$sql_r = "select
#			id,
#			local_graph_template_graph_id,
#			local_graph_id,
#			graph_template_id,
#			image_format_id,
#			title,
#			title_cache,
#			height,
#			width,
#			upper_limit,
#			lower_limit,
#			vertical_label,
#			slope_mode,
#			auto_scale,
#			auto_scale_opts,
#			auto_scale_log,
#			scale_log_units,
#			auto_scale_rigid,
#			auto_padding,
#			base_value,
#			grouping,
#			export,
#			unit_value,
#			unit_exponent_value
#		from graph_templates_graph
#		where local_graph_template_graph_id > 0 ;";

	$sql_r = "select
			graph_templates_graph.id,
			graph_templates_graph.local_graph_template_graph_id,
			graph_templates_graph.local_graph_id,
			graph_templates.hash,
			graph_templates_graph.image_format_id,
			graph_templates_graph.title,
			graph_templates_graph.title_cache,
			graph_templates_graph.height,
			graph_templates_graph.width,
			graph_templates_graph.upper_limit,
			graph_templates_graph.lower_limit,
			graph_templates_graph.vertical_label,
			graph_templates_graph.slope_mode,
			graph_templates_graph.auto_scale,
			graph_templates_graph.auto_scale_opts,
			graph_templates_graph.auto_scale_log,
			graph_templates_graph.scale_log_units,
			graph_templates_graph.auto_scale_rigid,
			graph_templates_graph.auto_padding,
			graph_templates_graph.base_value,
			graph_templates_graph.grouping,
			graph_templates_graph.export,
			graph_templates_graph.unit_value,
			graph_templates_graph.unit_exponent_value
		from graph_templates_graph, graph_templates
		where graph_templates_graph.local_graph_template_graph_id > 0
		  and graph_templates_graph.graph_template_id = graph_templates.id ;";

	$sth_r = $db_r->prepare($sql_r);
	$sth_r->execute;

	while (my $arr_ref = $sth_r->fetchrow_arrayref) {
		my (
			$TABLE_id,
			$TABLE_local_graph_template_graph_id,
			$TABLE_local_graph_id,
			$TABLE_graph_templates_hash,
			$TABLE_image_format_id,
			$TABLE_title,
			$TABLE_title_cache,
			$TABLE_height,
			$TABLE_width,
			$TABLE_upper_limit,
			$TABLE_lower_limit,
			$TABLE_vertical_label,
			$TABLE_slope_mode,
			$TABLE_auto_scale,
			$TABLE_auto_scale_opts,
			$TABLE_auto_scale_log,
			$TABLE_scale_log_units,
			$TABLE_auto_scale_rigid,
			$TABLE_auto_padding,
			$TABLE_base_value,
			$TABLE_grouping,
			$TABLE_export,
			$TABLE_unit_value,
			$TABLE_unit_exponent_value
		) = @$arr_ref;

		$sql_w = "select id from graph_templates where hash = '" . $TABLE_graph_templates_hash . "';";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		$arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($graph_template_id) = @$arr_w_ref;
		$sth_w->finish;

		$sql_w = "select id from graph_local where ref_id = '" . $TABLE_local_graph_id . "' and ref_hostname = '" . $db_r_host . "';";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		$arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($local_graph_id) = @$arr_w_ref;
		$sth_w->finish;

		$sql_w = "select count(*) from graph_templates_graph
		where local_graph_template_graph_id = '" . $graph_template_id . "'
		  and local_graph_id = '" .                $local_graph_id . "'
		  and graph_template_id = '" .             $graph_template_id . "'
		  and ref_id = '" .                        $TABLE_id . "'
		  and ref_hostname = '" .                  $db_r_host . "';";
		$sth_w = $db_w->prepare($sql_w);
		$sth_w->execute;
		$arr_w_ref = $sth_w->fetchrow_arrayref;
		my ($graph_templates_graph_duplicate) = @$arr_w_ref;
		$sth_w->finish;

	        if($graph_templates_graph_duplicate == 0) {
	                $sql_w = "insert into graph_templates_graph (
	        		local_graph_template_graph_id,
	        		local_graph_id,
	        		graph_template_id,
	        		image_format_id,
	        		title,
	        		title_cache,
	        		height,
	        		width,
	        		upper_limit,
	        		lower_limit,
	        		vertical_label,
	        		slope_mode,
	        		auto_scale,
	        		auto_scale_opts,
	        		auto_scale_log,
	        		scale_log_units,
	        		auto_scale_rigid,
	        		auto_padding,
	        		base_value,
	        		grouping,
	        		export,
	        		unit_value,
	        		unit_exponent_value,
	                        ref_id,
	                        ref_hostname
	        	) values (
	        		'" . $graph_template_id . "',
	        		'" . $local_graph_id . "',
	        		'" . $graph_template_id . "',
	        		'" . $TABLE_image_format_id . "',
	        		'" . $TABLE_title . "',
	        		'" . $TABLE_title_cache . "',
	        		'" . $TABLE_height . "',
	        		'" . $TABLE_width . "',
	        		'" . $TABLE_upper_limit . "',
	        		'" . $TABLE_lower_limit . "',
	        		'" . $TABLE_vertical_label . "',
	        		'" . $TABLE_slope_mode . "',
	        		'" . $TABLE_auto_scale . "',
	        		'" . $TABLE_auto_scale_opts . "',
	        		'" . $TABLE_auto_scale_log . "',
	        		'" . $TABLE_scale_log_units . "',
	        		'" . $TABLE_auto_scale_rigid . "',
	        		'" . $TABLE_auto_padding . "',
	        		'" . $TABLE_base_value . "',
	        		'" . $TABLE_grouping . "',
	        		'" . $TABLE_export . "',
	        		'" . $TABLE_unit_value . "',
	        		'" . $TABLE_unit_exponent_value . "',
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
