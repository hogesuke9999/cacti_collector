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

sub delete_table_graph_templates_graph {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_w, $sth_w, $arr_w_ref;
	my $sql_w2, $sth_w2, $arr_w2_ref;

	print "***** Delete Table Name = graph_templates_graph *****\n";

	$sql_w = "select ref_id from graph_templates_graph where ref_hostname = '" . $db_r_host . "';";
	$sth_w = $db_w->prepare($sql_w);
	$sth_w->execute;

	while (my $arr_ref = $sth_w->fetchrow_arrayref) {
		my ($TABLE_ref_id) = @$arr_ref;

		$sql_r = "select count(*) from graph_templates_graph where id = '" . $TABLE_ref_id . "';";
		$sth_r = $db_r->prepare($sql_r);
		$sth_r->execute;

		$arr_r_ref = $sth_r->fetchrow_arrayref;
		my ($id_exist) = @$arr_r_ref;
		$sth_r->finish;

		if($id_exist < 1) {
			$sql_w2 = "delete from graph_templates_graph where ref_id = '" . $TABLE_ref_id . "' and ref_hostname = '" . $db_r_host . "';";
			print "Delete : " . $sql_w . "\n";
	        	$db_w->do($sql_w2);
		}
	}
}

1;
