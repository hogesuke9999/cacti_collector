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
	my $sql_w2, $sth_w2, $arr_w2_ref;

	print "***** Delete Table Name = graph_templates_item *****\n";

	$sql_w = "select ref_id from graph_templates_item where ref_hostname = '" . $db_r_host . "';";
	$sth_w = $db_w->prepare($sql_w);
	$sth_w->execute;

	while (my $arr_ref = $sth_w->fetchrow_arrayref) {
		my ($TABLE_ref_id) = @$arr_ref;

		$sql_r = "select count(*) from graph_templates_item where id = '" . $TABLE_ref_id . "';";
		$sth_r = $db_r->prepare($sql_r);
		$sth_r->execute;

		$arr_r_ref = $sth_r->fetchrow_arrayref;
		my ($id_exist) = @$arr_r_ref;
		$sth_r->finish;

		if($id_exist < 1) {
			$sql_w2 = "delete from graph_templates_item where ref_id = '" . $TABLE_ref_id . "' and ref_hostname = '" . $db_r_host . "';";
			print "Delete : " . $sql_w . "\n";
	        	$db_w->do($sql_w2);
		}
	}
}

1;
