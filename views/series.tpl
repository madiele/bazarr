<html>
	<head>
		<!DOCTYPE html>
		<script src="https://code.jquery.com/jquery-latest.min.js"></script>
		<script src="https://cdn.jsdelivr.net/semantic-ui/latest/semantic.min.js"></script>
		<script src="https://semantic-ui.com/javascript/library/tablesort.js"></script>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/semantic-ui/latest/semantic.min.css">
		
		<link rel="apple-touch-icon" sizes="120x120" href="/static/apple-touch-icon.png">
		<link rel="icon" type="image/png" sizes="32x32" href="/static/favicon-32x32.png">
		<link rel="icon" type="image/png" sizes="16x16" href="/static/favicon-16x16.png">
		<link rel="manifest" href="/static/manifest.json">
		<link rel="mask-icon" href="/static/safari-pinned-tab.svg" color="#5bbad5">
		<link rel="shortcut icon" href="/static/favicon.ico">
		<meta name="msapplication-config" content="/static/browserconfig.xml">
		<meta name="theme-color" content="#ffffff">
		
		<title>Bazarr</title>
		
		<style>
			body {
				background-color: #272727;
			}
			#divmenu {
				background-color: #272727;
				opacity: 0.9;
				padding-top: 2em;
				padding-bottom: 1em;
				padding-left: 1em;
				padding-right: 128px;
			}
			#fondblanc {
				background-color: #ffffff;
				border-radius: 0px;
				box-shadow: 0px 0px 5px 5px #ffffff;
				margin-top: 32px;
			}
			#tableseries {
				padding: 3em;
			}
			#divdetails {
				min-height: 250px;
			}
		</style>
	</head>
	<body>
		<div id='loader' class="ui page dimmer">
		   	<div class="ui indeterminate text loader">Loading...</div>
		</div>
		<div id="divmenu" class="ui container">
			<div style="background-color:#272727;" class="ui inverted borderless labeled icon huge menu four item">
				<a href="/"><img style="margin-right:32px;" class="logo" src="/static/logo128.png"></a>
				<div style="height:80px;" class="ui container">
					<a class="item" href="/">
						<i class="play icon"></i>
						Series
					</a>
					<a class="item" href="/history">
						<i class="wait icon"></i>
						History
					</a>
					<a class="item" href="/settings">
						<i class="settings icon"></i>
						Settings
					</a>
					<a class="item" href="/system">
						<i class="laptop icon"></i>
						System
					</a>
				</div>
			</div>
		</div>
			
		<div id="fondblanc" class="ui container">
			<table id="tableseries" class="ui very basic selectable sortable table">
				<thead>
					<tr>
						<th class="sorted ascending">Name</th>
						<th>Status</th>
						<th>Path</th>
						<th>Language</th>
						<th>Hearing-impaired</th>
						<th class="no-sort"></th>
					</tr>
				</thead>
				<tbody>
				%import ast
				%import os
				%for row in rows:
					<tr class="selectable">
						<td><a href="/episodes/{{row[5]}}">{{row[1]}}</a></td>
						<td>
						%if os.path.exists(row[2]):
							<div class="ui inverted basic compact icon" data-tooltip="Path exist" data-inverted="">
								<i class="ui checkmark icon"></i>
							</div>
						%else:
							<div class="ui inverted basic compact icon" data-tooltip="Path not found. Is your path substitution settings correct?" data-inverted="">
								<i class="ui warning sign icon"></i>
							</div>
						%end
						</td>
						<td>
						{{row[2]}}
						</td>
						<td>
							%subs_languages = ast.literal_eval(str(row[3]))
							%if subs_languages is not None:
								%for subs_language in subs_languages:
									<div class="ui tiny label">{{subs_language}}</div>
								%end
							%end
						</td>
						<td>{{row[4]}}</td>
						<td>
							<%
							subs_languages_list = []
							if subs_languages is not None:
								for subs_language in subs_languages:
									subs_languages_list.append(subs_language)
								end
							end
							%>
							<div class="config ui inverted basic compact icon" data-tooltip="Edit series" data-inverted="" data-tvdbid="{{row[0]}}" data-title="{{row[1]}}" data-poster="{{row[6]}}" data-languages="{{!subs_languages_list}}" data-hearing-impaired="{{row[4]}}">
								<i class="ui black configure icon"></i>
							</div>
						</td>
					</tr>
				%end
				</tbody>
			</table>
		</div>

		<div class="ui small modal">
			<div class="header">
				<div id="series_title"></div>
			</div>
			<div class="content">
				<form name="series_form" id="series_form" action="" method="post" class="ui form">
					<div id="divdetails" class="ui grid">
						<div class="four wide column">
							<img id="series_poster" class="ui image" src="">
						</div>
						<div class="twelve wide column">
							<div class="ui grid">
								<div class="middle aligned row">
									<div class="right aligned five wide column">
										<label>Languages</label>
									</div>
									<div class="nine wide column">
										<select name="languages" id="series_languages" multiple="" class="ui fluid selection dropdown">
											<option value="">Languages</option>
											%for language in languages:
											<option value="{{language[0]}}">{{language[1]}}</option>
											%end
										</select>
									</div>
								</div>
								<div class="middle aligned row">
									<div class="right aligned five wide column">
										<label>Hearing-impaired</label>
									</div>
									<div class="nine wide column">
										<div id="series_hearing-impaired_div" class="ui toggle checkbox">
									    	<input name="hearing_impaired" id="series_hearing-impaired" type="checkbox">
									    	<label></label>
									    </div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</form>
			</div>
			<div class="actions">
				<button class="ui cancel button" >Cancel</button>
				<button type="submit" name="save" value="save" form="series_form" class="ui blue approve button">Save</button>
			</div>
		</div>
	</body>
</html>


<script>
	if (sessionStorage.scrolly) {
	    $(window).scrollTop(sessionStorage.scrolly);
	    sessionStorage.clear();
	}

	$('table').tablesort();

	$('a').click(function(){
		$('#loader').addClass('active');
	})

	$('.modal')
		.modal({
	    	autofocus: false
		})
	;

	$('.config').click(function(){
		sessionStorage.scrolly=$(window).scrollTop();

		$('#series_form').attr('action', '/edit_series/' + $(this).data("tvdbid"));

		$("#series_title").html($(this).data("title"));
		$("#series_poster").attr("src", "/image_proxy" + $(this).data("poster"));
		
		$('#series_languages').dropdown('clear');
		var languages_array = eval($(this).data("languages"));
		$('#series_languages').dropdown('set selected',languages_array);
		
		if ($(this).data("hearing-impaired") == "True") {
			$("#series_hearing-impaired_div").checkbox('check');
		} else {
			$("#series_hearing-impaired_div").checkbox('uncheck');
		}
		
		$('.small.modal').modal('show');
	})

	$('#series_languages').dropdown();

</script>