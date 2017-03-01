# Procedure to get tool list from a Galaxy instance

1. Install pip (version pip 9.0.1)
2. Install virtualenv `pip install virtualenv`
3. `virtualenv .venv`
4. `source .venv/bin/activate`
5. `pip install requests`
6. `pip install PyYAML`
7. `pip install virtualenv`
8. `git clone https://github.com/galaxyproject/ephemeris.git`
9. `cd ephemeris`
10. `python get_tool_list_from_galaxy.py --help`
11. `python get_tool_list_from_galaxy.py -g https://mississippi.snv.jussieu.fr/ -o mississippi_tool_list.yml`
12. `python get_tool_list_from_galaxy.py --include_tool_panel_id -g https://mississippi.snv.jussieu.fr/ -o mississippi_tool_list_panelIDs.yml`

The two files generated are in tool_lists

Then

Grep `(^  tool_shed_url.+)\r` replace `\1\r  install_resolver_dependencies: True\r`

to generate the file `mississippi_tool_list_with_ install_resolver_dependencies.yml`

we have also to include the datamanagers tools in the list !
