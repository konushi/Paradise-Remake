
/datum/admins/proc/player_panel_new()//The new one
	if(!usr.client.holder)
		return
	// This stops the panel from being invoked by mentors who press F7.
	if(!check_rights(R_ADMIN))
		message_admins("[key_name_admin(usr)] attempted to invoke player panel without admin rights. If this is a mentor, its a chance they accidentally hit F7. If this is NOT a mentor, there is a high chance an exploit is being used")
		return
	var/dat = "<html><meta charset='utf-8'><head><title>Admin Player Panel</title></head>"

	//javascript, the part that does most of the work~
	dat += {"

		<head>
			<script type='text/javascript'>

				var locked_tabs = new Array();

				function updateSearch(){


					var filter_text = document.getElementById('filter');
					var filter = filter_text.value.toLowerCase();

					if(complete_list != null && complete_list != ""){
						var mtbl = document.getElementById("maintable_data_archive");
						mtbl.innerHTML = complete_list;
					}

					if(filter.value == ""){
						return;
					}else{

						var maintable_data = document.getElementById('maintable_data');
						var ltr = maintable_data.getElementsByTagName("tr");
						for(var i = 0; i < ltr.length; ++i)
						{
							try{
								var tr = ltr\[i\];
								if(tr.getAttribute("id").indexOf("data") != 0){
									continue;
								}
								var ltd = tr.getElementsByTagName("td");
								var td = ltd\[0\];
								var lsearch = td.getElementsByTagName("b");
								var search = lsearch\[0\];
								//var inner_span = li.getElementsByTagName("span")\[1\] //Should only ever contain one element.
								//document.write("<p>"+search.innerText+"<br>"+filter+"<br>"+search.innerText.indexOf(filter))
								if(search.innerText.toLowerCase().indexOf(filter) == -1)
								{
									//document.write("a");
									//ltr.removeChild(tr);
									td.innerHTML = "";
									i--;
								}
							}catch(err) {   }
						}
					}

					var count = 0;
					var index = -1;
					var debug = document.getElementById("debug");

					locked_tabs = new Array();

				}

				function expand(id,job,name,real_name,image,key,ip,antagonists,mobUID,client_ckey,eyeUID){

					clearAll();

					var span = document.getElementById(id);

					body = "<table><tr><td>";

					body += "</td><td align='center'>";

					body += "<font size='2'><b>"+job+" "+name+"</b><br><b>Real name "+real_name+"</b><br><b>Played by "+key+" ("+ip+")</b></font>"

					body += "</td><td align='center'>";

					body += "<a href='byond://?src=[UID()];adminplayeropts="+mobUID+"'>PP</a> - "
					body += "<a href='byond://?src=[UID()];shownoteckey="+key+"'>N</a> - "
					body += "<a href='byond://?_src_=vars;Vars="+mobUID+"'>VV</a> - "
					body += "<a href='byond://?src=[UID()];traitor="+mobUID+"'>TP</a> - "
					body += "<a href='byond://?src=[usr.UID()];priv_msg="+client_ckey+"'>PM</a> - "
					body += "<a href='byond://?src=[UID()];subtlemessage="+mobUID+"'>SM</a> - "
					body += "<a href='byond://?src=[UID()];adminplayerobservefollow="+mobUID+"'>FLW</a> - "
					body += "<a href='byond://?src=[UID()];adminalert="+mobUID+"'>ALERT</a> - "
					body += "<a href='byond://?src=[UID()];adminobserve="+mobUID+"'>OBS</a>"
					if(eyeUID)
						body += "|<a href='byond://?src=[UID()];adminplayerobservefollow="+eyeUID+"'>EYE</a>"
					body += "<br>"
					if(antagonists)
						body += "<font size='2'><a href='byond://?src=[UID()];check_antagonist=1'><font color='red'><b>"+antagonists+"</b></font></a></font>";

					body += "</td></tr></table>";


					span.innerHTML = body
				}

				function clearAll(){
					var spans = document.getElementsByTagName('span');
					for(var i = 0; i < spans.length; i++){
						var span = spans\[i\];

						var id = span.getAttribute("id");

						if(!(id.indexOf("item")==0))
							continue;

						var pass = 1;

						for(var j = 0; j < locked_tabs.length; j++){
							if(locked_tabs\[j\]==id){
								pass = 0;
								break;
							}
						}

						if(pass != 1)
							continue;




						span.innerHTML = "";
					}
				}

				function addToLocked(id,link_id,notice_span_id){
					var link = document.getElementById(link_id);
					var decision = link.getAttribute("name");
					if(decision == "1"){
						link.setAttribute("name","2");
					}else{
						link.setAttribute("name","1");
						removeFromLocked(id,link_id,notice_span_id);
						return;
					}

					var pass = 1;
					for(var j = 0; j < locked_tabs.length; j++){
						if(locked_tabs\[j\]==id){
							pass = 0;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs.push(id);
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "<font color='red'>Locked</font> ";
					//link.setAttribute("onClick","attempt('"+id+"','"+link_id+"','"+notice_span_id+"');");
					//document.write("removeFromLocked('"+id+"','"+link_id+"','"+notice_span_id+"')");
					//document.write("aa - "+link.getAttribute("onClick"));
				}

				function attempt(ab){
					return ab;
				}

				function removeFromLocked(id,link_id,notice_span_id){
					//document.write("a");
					var index = 0;
					var pass = 0;
					for(var j = 0; j < locked_tabs.length; j++){
						if(locked_tabs\[j\]==id){
							pass = 1;
							index = j;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs\[index\] = "";
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "";
					//var link = document.getElementById(link_id);
					//link.setAttribute("onClick","addToLocked('"+id+"','"+link_id+"','"+notice_span_id+"')");
				}

				function selectTextField(){
					var filter_text = document.getElementById('filter');
					filter_text.focus();
					filter_text.select();
				}

			</script>
		</head>


	"}

	//body tag start + onload and onkeypress (onkeyup) javascript event calls
	dat += "<body onload='selectTextField(); updateSearch();' onkeyup='updateSearch();'>"

	//title + search bar
	dat += {"

		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable'>
			<tr id='title_tr'>
				<td align='center'>
					<font size='5'><b>Player panel</b></font><br>
					Hover over a line to see more information | [check_rights(R_ADMIN,0) ? "<a href='byond://?src=[UID()];check_antagonist=1'>Check antagonists</a> | Kick <a href='byond://?_src_=holder;kick_all_from_lobby=1;afkonly=0'>everyone</a>/<a href='byond://?_src_=holder;kick_all_from_lobby=1;afkonly=1'>AFKers</a> in lobby" : "" ]
					<p>
				</td>
			</tr>
			<tr id='search_tr'>
				<td align='center'>
					<b>Search:</b> <input type='text' id='filter' value='' style='width:300px;'>
				</td>
			</tr>
	</table>

	"}

	//player table header
	dat += {"
		<span id='maintable_data_archive'>
		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable_data'>"}

	var/list/mobs = sortmobs()
	var/i = 1
	for(var/mob/M in mobs)
		if(M.ckey)
			if(M.client)
				if(M.client?.holder?.big_brother && !check_rights(R_PERMISSIONS, FALSE))		// normal admins can't see BB
					continue

			var/color = "#e6e6e6"
			if(i%2 == 0)
				color = "#f2f2f2"
			var/antagonist_string = get_antag_type_truncated_plaintext_string(M)

			var/M_job = ""

			if(isliving(M))

				if(iscarbon(M)) //Carbon stuff
					if(issmall(M))
						M_job = "Monkey"
					else if(ishuman(M))
						M_job = M.job
					else if(isslime(M))
						M_job = "slime"

					else if(isalien(M)) //aliens
						if(islarva(M))
							M_job = "Alien larva"
						else
							M_job = "Alien"
					else
						M_job = "Carbon-based"

				else if(issilicon(M)) //silicon
					if(is_ai(M))
						M_job = "AI"
					else if(ispAI(M))
						M_job = "pAI"
					else if(isrobot(M))
						M_job = "Cyborg"
					else
						M_job = "Silicon-based"

				else if(isanimal_or_basicmob(M)) //simple animals
					if(iscorgi(M))
						M_job = "Corgi"
					else
						M_job = "Animal"

				else
					M_job = "Living"

			else if(isnewplayer(M))
				M_job = "New player"

			else if(isobserver(M))
				M_job = "Ghost"

			M_job = replacetext(M_job, "'", "")
			M_job = replacetext(M_job, "\"", "")
			M_job = replacetext(M_job, "\\", "")

			var/M_name = M.name
			M_name = replacetext(M_name, "'", "")
			M_name = replacetext(M_name, "\"", "")
			M_name = replacetext(M_name, "\\", "")
			var/M_rname = M.real_name
			M_rname = replacetext(M_rname, "'", "")
			M_rname = replacetext(M_rname, "\"", "")
			M_rname = replacetext(M_rname, "\\", "")

			var/M_key = M.key
			M_key = replacetext(M_key, "'", "")
			M_key = replacetext(M_key, "\"", "")
			M_key = replacetext(M_key, "\\", "")

			var/M_eyeUID = ""
			if(is_ai(M))
				var/mob/living/silicon/ai/A = M
				if(A.client && A.eyeobj) // No point following clientless AI eyes
					M_eyeUID = "[A.eyeobj.UID()]"
			var/client_ckey = M.client ? M.client.ckey : null
			//output for each mob
			dat += {"

				<tr id='data[i]' name='[i]' onClick="addToLocked('item[i]','data[i]','notice_span[i]')">
					<td align='center' bgcolor='[color]'>
						<span id='notice_span[i]'></span>
						<a id='link[i]'
						onmouseover='expand("item[i]","[M_job]","[M_name]","[M_rname]","--unused--","[M_key]","[M.lastKnownIP]","[antagonist_string]","[M.UID()]","[client_ckey]","[M_eyeUID]")'
						>
						<b id='search[i]'>[M_name] - [M_rname] - [M_key] ([M_job])</b>
						</a>
						<br><span id='item[i]'></span>
					</td>
				</tr>

			"}

			i++


	//player table ending
	dat += {"
		</table>
		</span>

		<script type='text/javascript'>
			var maintable = document.getElementById("maintable_data_archive");
			var complete_list = maintable.innerHTML;
		</script>
	</body></html>
	"}

	usr << browse(dat, "window=players;size=600x480")


/datum/admins/proc/check_antagonists_line(mob/M, caption = "", close = 1)
	var/logout_status
	logout_status = M.client ? "" : " <i>(logged out)</i>"
	var/dname = M.real_name
	var/area/A = get_area(M)
	if(!dname)
		dname = M

	return {"<tr><td><a href='byond://?src=[UID()];adminplayeropts=[M.UID()]'>[dname]</a><b>[caption]</b>[logout_status][istype(A, /area/station/security/permabrig) ? "<b><font color=red> (PERMA) </b></font>" : ""][M.stat == DEAD ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>
		<td><a href='byond://?src=[usr.UID()];priv_msg=[M.client?.ckey]'>PM</a> [ADMIN_FLW(M, "FLW")] [ADMIN_OBS(M, "OBS")] </td>[close ? "</tr>" : ""]"}

/datum/admins/proc/check_antagonists()
	if(!check_rights(R_ADMIN))
		return
	if(SSticker && SSticker.current_state >= GAME_STATE_PLAYING)
		var/dat = "<html><meta charset='utf-8'><head><title>Round Status</title></head><body><h1><b>Round Status</b></h1>"
		dat += "Current Game Mode: <b>[SSticker.mode.name]</b><br>"
		if(istype(SSticker.mode, /datum/game_mode/dynamic))
			var/datum/game_mode/dynamic/dynamic = SSticker.mode
			dat += "Rulesets: <b>[english_list(dynamic.rulesets + dynamic.implied_rulesets)]</b><br>"
		dat += "Round Duration: <b>[round(ROUND_TIME / 36000)]:[add_zero(num2text(ROUND_TIME / 600 % 60), 2)]:[add_zero(num2text(ROUND_TIME / 10 % 60), 2)]</b><br>"
		dat += "<b>Emergency shuttle</b><br>"
		if(SSshuttle.emergency.mode < SHUTTLE_CALL)
			dat += "<a href='byond://?src=[UID()];call_shuttle=1'>Call Shuttle</a><br>"
		else
			var/timeleft = SSshuttle.emergency.timeLeft()
			if(SSshuttle.emergency.mode < SHUTTLE_DOCKED)
				dat += "ETA: <a href='byond://?_src_=holder;edit_shuttle_time=1'>[seconds_to_full_clock(timeleft)]</a><br>"
				dat += "<a href='byond://?_src_=holder;call_shuttle=2'>Send Back</a><br>"
			else
				dat += "ETA: <a href='byond://?_src_=holder;edit_shuttle_time=1'>[seconds_to_full_clock(timeleft)]</a><br>"

		dat += "<a href='byond://?src=[UID()];delay_round_end=1'>[SSticker.delay_end ? "End Round Normally" : "Delay Round End"]</a><br>"
		dat += "<br><b>Antagonist Teams</b><br>"
		dat += "<a href='byond://?src=[UID()];check_teams=1'>View Teams</a><br>"
		if(length(SSticker.mode.syndicates))
			dat += "<br><table cellspacing=5><tr><td><B>Syndicates</B></td><td></td></tr>"
			for(var/datum/mind/N in SSticker.mode.syndicates)
				var/mob/M = N.current
				if(M)
					dat += check_antagonists_line(M)
				else
					dat += "<tr><td><i>Nuclear Operative not found!</i></td></tr>"
			dat += "</table><br><table><tr><td><B>Nuclear Disk(s)</B></td></tr>"
			for(var/obj/item/disk/nuclear/N in GLOB.poi_list)
				dat += "<tr><td>[N.name], "
				var/atom/disk_loc = N.loc
				while(!isturf(disk_loc))
					if(ismob(disk_loc))
						var/mob/M = disk_loc
						dat += "carried by <a href='byond://?src=[UID()];adminplayeropts=[M.UID()]'>[M.real_name]</a> "
					if(isobj(disk_loc))
						var/obj/O = disk_loc
						dat += "in \a [O.name] "
					disk_loc = disk_loc.loc
				dat += "in [disk_loc.loc] at ([disk_loc.x], [disk_loc.y], [disk_loc.z])</td></tr>"
			dat += "</table>"

		if(SSticker.mode.rev_team)
			dat += "<br><table cellspacing=5><tr><td><B>Revolutionaries</B></td><td></td></tr>"
			for(var/datum/mind/N in SSticker.mode.head_revolutionaries)
				var/mob/M = N.current
				if(!M)
					dat += "<tr><td><i>Head Revolutionary not found!</i></td></tr>"
				else
					dat += check_antagonists_line(M, "(leader)")
			for(var/datum/mind/N in SSticker.mode.revolutionaries)
				var/mob/M = N.current
				if(M)
					dat += check_antagonists_line(M)
			dat += "</table><table cellspacing=5><tr><td><B>Target(s)</B></td><td></td><td><B>Location</B></td></tr>"
			for(var/datum/mind/N in SSticker.mode.get_living_heads())
				var/mob/M = N.current
				if(M)
					dat += check_antagonists_line(M)
					var/turf/mob_loc = get_turf(M)
					dat += "<td>[mob_loc.loc]</td></tr>"
				else
					dat += "<tr><td><i>Head not found!</i></td></tr>"
			dat += "</table>"


		if(length(SSticker.mode.blob_overminds))
			dat += check_role_table("Blob Overminds", SSticker.mode.blob_overminds)
			dat += "<i>Blob Tiles: [length(GLOB.blobs)]</i>"

		if(length(SSticker.mode.changelings))
			dat += check_role_table("Changelings", SSticker.mode.changelings)

		if(length(SSticker.mode.wizards))
			dat += check_role_table("Wizards", SSticker.mode.wizards)

		if(length(SSticker.mode.apprentices))
			dat += check_role_table("Apprentices", SSticker.mode.apprentices)

		/*if(length(ticker.mode.ninjas))
			dat += check_role_table("Ninjas", ticker.mode.ninjas)*/

		if(SSticker.mode.cult_team)
			dat += check_role_table("Cultists", SSticker.mode.cult_team.members)
			dat += "<a href='byond://?src=[UID()];check_teams=1'>View Cult Team & Controls</a><br>"

		if(length(SSticker.mode.traitors))
			dat += check_role_table("Traitors", SSticker.mode.traitors)

		// SS220 EDIT - START
		if(length(SSticker.mode.blood_brothers))
			dat += check_role_table("Blood Brothers", SSticker.mode.blood_brothers)

		if(length(SSticker.mode.vox_raiders))
			dat += check_role_table("Vox Raiders", SSticker.mode.vox_raiders)
		// SS220 EDIT - END

		if(length(SSticker.mode.implanted))
			dat += check_role_table("Mindslaves", SSticker.mode.implanted)

		if(length(SSticker.mode.abductors))
			dat += check_role_table("Abductors", SSticker.mode.abductors)

		if(length(SSticker.mode.abductees))
			dat += check_role_table("Abductees", SSticker.mode.abductees)

		if(length(SSticker.mode.vampires))
			dat += check_role_table("Vampires", SSticker.mode.vampires)

		if(length(SSticker.mode.mindflayers))
			dat += check_role_table("Mindflayers", SSticker.mode.mindflayers)

		if(length(SSticker.mode.vampire_enthralled))
			dat += check_role_table("Vampire Thralls", SSticker.mode.vampire_enthralled)

		if(length(SSticker.mode.xenos))
			dat += check_role_table("Xenos", SSticker.mode.xenos)

		if(length(SSticker.mode.superheroes))
			dat += check_role_table("Superheroes", SSticker.mode.superheroes)

		if(length(SSticker.mode.supervillains))
			dat += check_role_table("Supervillains", SSticker.mode.supervillains)

		if(length(SSticker.mode.greyshirts))
			dat += check_role_table("Greyshirts", SSticker.mode.greyshirts)

		if(length(SSticker.mode.eventmiscs))
			dat += check_role_table("Event Roles", SSticker.mode.eventmiscs)

		if(length(SSticker.mode.zombies))
			dat += check_role_table("Zombies", SSticker.mode.zombies)

		if(length(SSticker.mode.zombie_infected))
			dat += check_role_table_mob("Pre-zombie infected", SSticker.mode.zombie_infected)

		if(length(GLOB.ts_spiderlist))
			var/list/spider_minds = list()
			for(var/mob/living/simple_animal/hostile/poison/terror_spider/S in GLOB.ts_spiderlist)
				if(S.ckey)
					spider_minds += S.mind
			if(length(spider_minds))
				dat += check_role_table("Terror Spiders", spider_minds)

				var/count_eggs = 0
				var/count_spiderlings = 0
				var/count_infected = 0
				for(var/obj/structure/spider/eggcluster/terror_eggcluster/E in GLOB.ts_egg_list)
					if(is_station_level(E.z))
						count_eggs += E.spiderling_number
				for(var/obj/structure/spider/spiderling/terror_spiderling/L in GLOB.ts_spiderling_list)
					if(!L.stillborn && is_station_level(L.z))
						count_spiderlings += 1
				count_infected = length(GLOB.ts_infected_list)
				dat += "<table cellspacing=5><tr><td>Growing TS on-station: [count_eggs] egg\s, [count_spiderlings] spiderling\s, [count_infected] infected</td></tr></table>"

		if(length(SSticker.mode.ert))
			dat += check_role_table("ERT", SSticker.mode.ert)

		//list active security force count, so admins know how bad things are
		var/list/sec_list = check_active_security_force()
		dat += "<br><table cellspacing=5><tr><td><b>Security</b></td><td></td></tr>"
		dat += "<tr><td>Total: </td><td>[sec_list[1]]</td>"
		dat += "<tr><td>Active: </td><td>[sec_list[2]]</td>"
		dat += "<tr><td>Dead: </td><td>[sec_list[3]]</td>"
		dat += "<tr><td>Antag: </td><td>[sec_list[4]]</td>"
		dat += "</table>"

		dat += "</body></html>"
		usr << browse(dat, "window=roundstatus;size=400x500")
	else
		alert("The game hasn't started yet!")

/datum/admins/proc/check_role_table(name, list/members, show_objectives=1)
	var/txt = "<br><table cellspacing=5><tr><td><b>[name]</b></td><td></td></tr>"
	for(var/datum/mind/M in members)
		txt += check_role_table_row(M.current, show_objectives)
	txt += "</table>"
	return txt

/datum/admins/proc/check_role_table_row(mob/M, show_objectives)
	if(!istype(M))
		return "<tr><td><i>Not found!</i></td></tr>"

	var/txt = check_antagonists_line(M, close = 0)

	if(show_objectives)
		txt += {"
			<td>
				<a href='byond://?src=[UID()];traitor=[M.UID()]'>Show Objective</a>
			</td>
		"}

	txt += "</tr>"
	return txt

/datum/admins/proc/check_role_table_mob(name, list/members, show_objectives=1)
	var/txt = "<br><table cellspacing=5><tr><td><b>[name]</b></td><td></td></tr>"
	for(var/mob/M in members)
		txt += check_role_table_row(M, show_objectives)
	txt += "</table>"
	return txt
