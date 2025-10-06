# Phased Build Plan

Phase 0 — Repo & Environment Foundation
	Goal: GitHub project boots with CI, formatting, and empty resources validated.
	Deliverables
		Repo root files (README.md, LICENSE, .gitignore, .luacheckrc, .stylua.toml).
		CI: ci.yml runs luacheck, stylua --check, JSON validation; release.yml zips /resources/[ess].
		Example configs: server.cfg.example, start_ess.cfg.example, txAdmin_recipe.yaml.
Phase 1 — Core (esf_core)
	Goal: Shared plumbing for all modules.
	Deliverables
		server/main.lua, event_bus.lua, logger.lua, db.lua (oxmysql), config_loader.lua, timekeeper.lua.
		Client: core.lua, notify.lua, markers.lua.
		Configs: permissions.json, server_settings.json, locales/en-US.json.
		SQL: 000_init.sql (users/roles/audit).
Phase 2 — Identity (esf_identity)
	Goal: First‑run landing page + 1–4 characters per account, last‑position resume.
	Deliverables
		Server: identity.lua, characters.lua, appearance.lua, persistence.lua.
		Client: landing.lua, spawn_client.lua.
		NUI: landing.html/js/css (4 slot selector, create/edit/delete).
		Config: character_limits.json, default_appearance.json.
		SQL: 001_accounts.sql, 002_characters.sql, 003_appearance.sql, 004_playtime.sql.
Phase 3 — Departments (esf_departments)
	Goal: Dept catalog, ranks/grades, roster lifecycle, vehicle/loadout policies.
	Deliverables
		Server: departments.lua, roster.lua, loadouts.lua, vehicles.lua.
		Client: blips.lua (dept colors/stations once world exists).
		Config: departments.json, ranks.json, roster_policies.json.
		SQL: 010_departments.sql, 011_ranks.sql, 012_roster.sql.
Phase 4 — World (esf_world)
	Goal: Stations, spawns, garages, armories, jails, training areas (config‑driven).
	Deliverables
		Server: stations.lua, spawns.lua, armory.lua, garage.lua, jail.lua, training.lua.
		Client: markers.lua, zones.lua, interactions.lua.
		NUI: spawn_select.html/js/css (choose station/bed/garage spawn).
		Config: stations/*.json, garages.json, armories.json, jails.json, training.json, map_blips.json.
		SQL: 020_stations.sql, 021_station_points.sql, 022_armory_items.sql, 023_garage_log.sql, 024_jail_log.sql.
Phase 5 — MDT (esf_mdt)
	Goal: Records backbone (persons/vehicles/properties/reports/evidence/warrants/BOLOs).
	Deliverables
		Server APIs (api_*.lua), search.lua, dispatch/AI bridges.
		NUI: index.html, app.js, styles.css.
		Configs: statutes.json, report_validations.json, search_indexes.json.
		SQL: 010–016 series.
Phase 6 — Dispatch AI (esf_dispatch)
	Goal: Call stacking, generation, priority/assignment, service requests.
	Deliverables
		Server: call_stack.lua, assignment.lua, generator.lua, evolution.lua, services/*, nlp/*, bridges/*.
		Client: radio_ui.lua quick statuses.
		NUI: console.html/js/css.
		Config: ten_codes.json, fire_codes.json, ems_codes.json, policies.json.
		SQL: 020–023 series.
Phase 7 — Police (esf_police)
	Goal: Patrol loop (stops, arrest, booking, evidence).
	Deliverables
		Server: patrol.lua, stops/*, arrest/*, evidence/*, investigations/*.
		Client: interactions.lua, radar.lua, weapons.lua, ui.lua.
		Config: use_of_force.json, arrest_codes.json, citation_codes.json.
		SQL: 030–032 series.
Phase 8 — AI World (esf_ai)
	Goal: Director + ped behavior (BT/GOAP), perception, traits/archetypes.
	Deliverables
		Server: director/*, behavior/*, perception/*, peds/*, bridges/dispatch.lua.
		Config: archetypes.json, traits_curves.json, director_policies.json, schedules.json.
		Data: /data/training + /data/seeds (optional for tuning).
		SQL: 040–042 series.
Phase 9 — Traffic AI (esf_ai_traffic)
	Goal: Siren yield, simple crash sim, pursuit logic.
	Deliverables
		Server: traffic_controller.lua, incidents.lua, pursuit.lua, natives/vehicle_tasks.lua.
		Client: driver_ai.lua, sensors.lua.
		Config: traffic_profiles.json, vehicle_classes.json, signals.json.
		SQL: 050_traffic_events.sql.
Phase 10 — Fire (esf_fire)
	Goal: Fire incidents, water/pump math, hose/vent/ladders, utilities, MVA.
	Deliverables
		Server: incidents.lua, preplans.lua, hydrants.lua, hose.lua, pump.lua, ventilation.lua, ladders.lua, utilities.lua, mva_extrication.lua.
		Client: fire_tools.lua, scba_hud.lua.
		NUI: pump_panel.html/js, scba_hud.html + styles.
		Config: pump_nozzles.json, hose_k_values.json, benchmarks.json, preplans.sample.json.
		SQL: 060–062 series.
Phase 11 — EMS (esf_ems)
	Goal: Patient model, vitals, interventions/meds, transport, ePCR/QA.
	Deliverables
		Server: patients.lua, vitals.lua, interventions.lua, meds.lua, monitor.lua, transport.lua, hospitals.lua, qa.lua.
		Client: monitor_ui.lua.
		NUI: monitor.html/js, assessment.html, styles.
		Config: protocols_cardiac.json, protocols_trauma.json, drugs.json, hospitals.json.
		SQL: 070–073 series.
Phase 12 — Integrations (esf_integrations)
	Goal: Discord/webhooks + CSV/JSON exporters.
	Deliverables
		Server: discord.lua, webhooks.lua, exporters/{csv,json}.lua.
		Config: discord.json, webhooks.json.
Phase 13 — Scenario Editor (esf_scenario_editor)
	Goal: In‑game admin tool for authoring/loading scenarios.
	Deliverables
		Server: editor.lua (save/load/validate schema).
		Client: editor_ui.lua.
		NUI: editor.html/js/css.
		Config: schema.json; Samples.
Phase 14 — Analytics (esf_analytics)
	Goal: KPI dashboard + metrics API/exporters.
	Deliverables
		Server: metrics.lua (collect), dash_api.lua (serve to NUI).
		NUI: dashboard.html/js/css.
		Config: metrics.json (what to collect, rollups).
Phase 15 — Polish & Release
	Goal: Performance, localization, docs, and packaging.
	Deliverables
		Perf pass (entity caps, AI culling, yield distances, tick budgets).
		Localization support (add locales & switch via server_settings.json).
		Docs finalized (ONBOARDING, DEPARTMENTS, STATIONS_AND_SPAWNS, CONTENT_CHECKLIST).
		GitHub Release artifact via release.yml.
	Go‑Live Checklist
		OneSync ON, mysql_connection_string set.
		All SQL applied in order; stations JSONs filled for your map.
		Departments/ranks configured; armory/garage catalogs valid.
		Landing NUI presents 1–4 slots; spawn selection works.
		Test flows: Traffic Stop → Arrest → Booking → Jail; Fire pump; EMS ROSC.
		Each phase: Code, docs, CI validation.