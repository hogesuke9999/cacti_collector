#!/bin/perl

use strict;
use warnings;
use DBI;

# 各テーブル登録用モジュールの読み込み
require "./lib/table_host.pl";
require "./lib/table_host_snmp_query.pl";
require "./lib/table_host_snmp_cache.pl";
require "./lib/table_poller_reindex.pl";
require "./lib/table_data_local.pl";
require "./lib/table_data_template_data.pl";
require "./lib/table_data_template_rrd.pl";
require "./lib/table_graph_local.pl";
require "./lib/table_graph_templates_graph.pl";
require "./lib/table_graph_templates_item.pl";
require "./lib/table_data_input_data.pl";
require "./lib/table_data_template_data_rra.pl";
require "./lib/table_poller_item.pl";
require "./lib/delete_table_graph_templates_item.pl";
require "./lib/delete_table_data_local.pl";
require "./lib/delete_table_data_template_data.pl";
require "./lib/delete_table_data_template_rrd.pl";
require "./lib/delete_table_graph_local.pl";
require "./lib/delete_table_graph_templates_graph.pl";
require "./lib/delete_table_host.pl";

# 書き込み用の接続設定
my $db_w_user = 'cacti';
my $db_w_pass = 'cactipass';
my $db_w_host = 'localhost';
my $db_w_port = '3306';
my $db_w_database = 'cacti';

# 読み込み用の接続設定の設定
my $conf_file = "./CactiTableCopy.cnf";
my $Collect_host = require $conf_file;

# 書き込み用接続 (コピー先)
#  コピー先用データソースに接続して接続用ハンドルを取得
#  データベースハンドル = db_w
my $db_w = DBI->connect("DBI:mysql:$db_w_database:$db_w_host:$db_w_port", $db_w_user, $db_w_pass)
or die "書き込み用(コピー先)の接続に失敗しました: $DBI::errstr";

for my $Collect_host_name (sort keys %$Collect_host) {
	my $db_r_host     = $Collect_host->{$Collect_host_name}{"db_r_host"};
	my $db_r_port     = $Collect_host->{$Collect_host_name}{"db_r_port"};
	my $db_r_user     = $Collect_host->{$Collect_host_name}{"db_r_user"};
	my $db_r_pass     = $Collect_host->{$Collect_host_name}{"db_r_pass"};
	my $db_r_database = $Collect_host->{$Collect_host_name}{"db_r_database"};

	print "$Collect_host_name\n";
	print "- db_r_host = " .     $db_r_host . "\n";
	print "- db_r_port = " .     $db_r_port . "\n";
	print "- db_r_user = " .     $db_r_user . "\n";
	print "- db_r_pass = " .     $db_r_pass . "\n";
	print "- db_r_database = " . $db_r_database . "\n";
	print "\n";

	# 読み込み用接続 (コピー元)
	#  コピー元用データソースに接続して接続用ハンドルを取得
	#  データベースハンドル = db_r
	my $db_r = DBI->connect("DBI:mysql:$db_r_database:$db_r_host:$db_r_port", $db_r_user, $db_r_pass)
	 or die "読み込み用(コピー元)の接続に失敗しました: $DBI::errstr";

#	# Devices関連の登録
#	&copy_table_host($db_w, $db_r, $db_r_host);
#	&copy_table_host_snmp_query($db_w, $db_r, $db_r_host);
#	&copy_table_host_snmp_cache($db_w, $db_r, $db_r_host);
#	&copy_table_poller_reindex($db_w, $db_r, $db_r_host);

#	# Data Sources関連の登録
#	&copy_table_data_local($db_w, $db_r, $db_r_host);
#	&copy_table_data_template_data($db_w, $db_r, $db_r_host);
#	&copy_table_data_template_rrd($db_w, $db_r, $db_r_host);
#	&copy_table_graph_local($db_w, $db_r, $db_r_host);
#	&copy_table_graph_templates_graph($db_w, $db_r, $db_r_host);
#	&copy_table_graph_templates_item($db_w, $db_r, $db_r_host);
#	&copy_table_data_input_data($db_w, $db_r, $db_r_host);
#	&copy_table_data_template_data_rra($db_w, $db_r, $db_r_host);
#	&copy_table_poller_item($db_w, $db_r, $db_r_host);

	# データ削除処理
	&delete_table_graph_templates_item($db_w, $db_r, $db_r_host);
	&delete_table_data_local($db_w, $db_r, $db_r_host);
	&delete_table_data_template_data($db_w, $db_r, $db_r_host);
	&delete_table_data_template_rrd($db_w, $db_r, $db_r_host);
#	&delete_table_graph_local($db_w, $db_r, $db_r_host);
#	&delete_table_graph_templates_graph($db_w, $db_r, $db_r_host);
#	&delete_table_host($db_w, $db_r, $db_r_host);

	# 読み込み用接続 (コピー先) の切断
	$db_r->disconnect or warn $db_r->errstr;
}

# 書き込み用接続 (コピー先) の切断
$db_w->disconnect or warn $db_w->errstr;
