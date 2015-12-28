#!/bin/perl

# Table Name = data_template_data
#
# +-----------------------------+-----------------------+------+-----+---------+----------------+
# | Field                       | Type                  | Null | Key | Default | Extra          |
# +-----------------------------+-----------------------+------+-----+---------+----------------+
# | id                          | mediumint(8) unsigned | NO   | PRI | NULL    | auto_increment |
# | local_data_template_data_id | mediumint(8) unsigned | NO   |     | 0       |                |
# | local_data_id               | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | data_template_id            | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | data_input_id               | mediumint(8) unsigned | NO   | MUL | 0       |                |
# | t_name                      | char(2)               | YES  |     | NULL    |                |
# | name                        | varchar(250)          | NO   |     |         |                |
# | name_cache                  | varchar(255)          | NO   |     |         |                |
# | data_source_path            | varchar(255)          | YES  |     | NULL    |                |
# | t_active                    | char(2)               | YES  |     | NULL    |                |
# | active                      | char(2)               | YES  |     | NULL    |                |
# | t_rrd_step                  | char(2)               | YES  |     | NULL    |                |
# | rrd_step                    | mediumint(8) unsigned | NO   |     | 0       |                |
# | t_rra_id                    | char(2)               | YES  |     | NULL    |                |
# +-----------------------------+-----------------------+------+-----+---------+----------------+

sub delete_table_data_template_data {
	# 引数の受理
	my ( $db_w, $db_r, $db_r_host) = @_;

	my $sql_r, $sth_r, $arr_r_ref;
	my $sql_w, $sth_w, $arr_w_ref;
	my $sql_w2, $sth_w2, $arr_w2_ref;

	print "***** Delete Table Name = data_template_data *****\n";

	$sql_w = "select ref_id from data_template_data where ref_hostname = '" . $db_r_host . "';";
	$sth_w = $db_w->prepare($sql_w);
	$sth_w->execute;

	while (my $arr_ref = $sth_w->fetchrow_arrayref) {
		my ($TABLE_ref_id) = @$arr_ref;

		$sql_r = "select count(*) from data_template_data where id = '" . $TABLE_ref_id . "';";
		$sth_r = $db_r->prepare($sql_r);
		$sth_r->execute;

		$arr_r_ref = $sth_r->fetchrow_arrayref;
		my ($id_exist) = @$arr_r_ref;
		$sth_r->finish;

		if($id_exist < 1) {
			$sql_w2 = "delete from data_template_data where ref_id = '" . $TABLE_ref_id . "' and ref_hostname = '" . $db_r_host . "';";
			print "Delete : " . $sql_w . "\n";
	        	$db_w->do($sql_w2);
		}
	}
}

1;
