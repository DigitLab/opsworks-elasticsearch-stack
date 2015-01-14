include_recipe "elasticsearch"

package "jq"

cron "elasticsearchbackup" do
    minute "0"
    hour "0"
    command "curl -s -S -XGET \"#{node["elasticsearch-backup"][:host]}/_snapshot/#{node["elasticsearch-backup"][:repository]}/_all?pretty=true\" | jq '.snapshots[] | .snapshot + \" \" + .end_time' | sed 's/^.\(.*\).$/\1/' | sort -k 2 -r | awk '{ if (NR > 30) { system(\"curl -XDELETE \" \"#{node["elasticsearch-backup"][:host]}/_snapshot/#{node["elasticsearch-backup"][:repository]}/\"$1) } } END { system(\"curl -XPUT \" \"#{node["elasticsearch-backup"][:host]}/_snapshot/#{node["elasticsearch-backup"][:repository]}/`date +\%s`\") }'"
    action :create
end