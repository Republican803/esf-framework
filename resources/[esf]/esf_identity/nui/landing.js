// nui/landing.js: Thin JS bridge → SendNUIMessage callbacks
let accountId = null;
let characters = [];
let departments = {};
let currentSlot = null;

window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.action === 'open') {
        accountId = data.accountId;
        departments = data.departments;  // From client
        document.getElementById('container').style.display = 'block';
        fetchCharacters();
    } else if (data.action === 'updateCharacters') {
        characters = data.characters;
        renderSlots();
    } else if (data.action === 'createResponse') {
        if (data.success) alert('Application approved! Character created.');
        else alert('Error: ' + data.data);
        fetchCharacters();
        closeModals();
    } else if (data.action === 'selectResponse') {
        if (!data.success) alert('Error: ' + data.data);
    } else if (data.action === 'deleteResponse') {
        if (data.success) alert('Deleted!');
        else alert('Error deleting');
        fetchCharacters();
    } else if (data.action === 'close') {
        document.getElementById('container').style.display = 'none';
    } else if (data.action === 'error') {
        alert(data.message);
    }
});

function fetchCharacters() {
    fetchNui('getCharacters', {accountId});
}

function renderSlots() {
    const slotsDiv = document.getElementById('slots');
    slotsDiv.innerHTML = '';
    for (let i = 1; i <= 4; i++) {
        const char = characters.find(c => c.slot === i);
        const slotDiv = document.createElement('div');
        slotDiv.className = 'slot fade-in';
        if (char) {
            slotDiv.innerHTML = `<p>Slot ${i}: ${char.char_name} (${char.age}) - ${char.dept} ${char.rank}</p>
                <button onclick="selectChar(${i})">Select</button>
                <button onclick="deleteChar(${i})">Delete</button>`;
        } else {
            slotDiv.innerHTML = `<p>Slot ${i}: Empty</p>
                <button onclick="startApplication(${i})">Apply</button>`;
        }
        slotsDiv.appendChild(slotDiv);
    }
}

function startApplication(slot) {
    currentSlot = slot;
    const deptSelect = document.getElementById('dept-select');
    deptSelect.innerHTML = Object.keys(departments).map(d => `<option value="${d}">${departments[d].name}</option>`).join('');
    deptSelect.onchange = updateDeptPreview;
    updateDeptPreview();  // Initial
    document.getElementById('application-modal').style.display = 'block';
}

function updateDeptPreview() {
    const dept = document.getElementById('dept-select').value;
    document.getElementById('dept-preview').src = `https://via.placeholder.com/300x200?text=${dept}+Preview`;  // Replace with real assets
}

document.getElementById('submit-app').addEventListener('click', () => {
    const name = document.getElementById('char-name').value;
    const age = parseInt(document.getElementById('char-age').value);
    const bio = document.getElementById('char-bio').value;
    const dept = document.getElementById('dept-select').value;
    if (!name || !age || !dept) return alert('Fill all fields');
    document.getElementById('application-modal').style.display = 'none';
    startEupSelection(dept);
});

function startEupSelection(dept) {
    const outfitSelect = document.getElementById('outfit-select');
    outfitSelect.innerHTML = departments[dept].eup_outfits.map((o, idx) => `<option value="${idx}">${o.name}</option>`).join('');
    document.getElementById('eup-modal').style.display = 'block';
}

document.getElementById('confirm-outfit').addEventListener('click', () => {
    const name = document.getElementById('char-name').value;
    const age = parseInt(document.getElementById('char-age').value);
    const bio = document.getElementById('char-bio').value;
    const dept = document.getElementById('dept-select').value;
    const outfitIdx = parseInt(document.getElementById('outfit-select').value);
    fetchNui('createCharacter', {accountId, slot: currentSlot, name, age, bio, dept, rank: 'recruit', outfit: outfitIdx});
});

function closeModals() {
    document.getElementById('application-modal').style.display = 'none';
    document.getElementById('eup-modal').style.display = 'none';
}

document.getElementById('cancel-app').addEventListener('click', closeModals);
document.getElementById('cancel-outfit').addEventListener('click', closeModals);

function selectChar(slot) {
    fetchNui('selectCharacter', {accountId, slot});
}

function deleteChar(slot) {
    if (confirm('Delete slot ' + slot + '?')) {
        fetchNui('deleteCharacter', {accountId, slot});
    }
}

document.getElementById('close').addEventListener('click', () => {
    fetchNui('closeNui');
});

// Fetch NUI helper
function fetchNui(event, data) {
    fetch(`https://${GetParentResourceName()}/${event}`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: JSON.stringify(data || {})
    });
}

// Departments from config (assume loaded or hardcoded; for JS, define here or fetch)
const departments = {
    "LSPD": {"name": "Los Santos Police Department", "spawn_coords": {"x": 441.2, "y": -982.0, "z": 30.7}},
    "LSCSO": {"name": "Los Santos County Sheriffs Office", "spawn_coords": {"x": 360.9, "y": -1584.0, "z": 29.3}},
    "LSPA": {"name": "Los Santos Port Authority", "spawn_coords": {"x": -458.0, "y": -2718.0, "z": 6.0}},
    "LSIAPD": {"name": "Los Santos International Airport Police", "spawn_coords": {"x": -1042.5, "y": -2744.0, "z": 21.4}},
    "BCSO": {"name": "Blaine County Sheriffs Office", "spawn_coords": {"x": 1853.8, "y": 3689.7, "z": 34.3}},
    "SSPD": {"name": "Sandy Shores Police Department", "spawn_coords": {"x": 1853.8, "y": 3689.7, "z": 34.3}},
    "PBPD": {"name": "Paleto Bay Police Department", "spawn_coords": {"x": -448.3, "y": 6010.2, "z": 31.7}},
    "SAGW": {"name": "San Andreas Game Wardens", "spawn_coords": {"x": 383.8, "y": 799.0, "z": 187.5}},
    "SAST": {"name": "San Andreas State Troopers", "spawn_coords": {"x": 2500.0, "y": -384.0, "z": 94.1}},
    "LSFD": {"name": "Los Santos Fire Department", "spawn_coords": {"x": 205.9, "y": -1643.4, "z": 29.8}},
    "LSIAFD": {"name": "Los Santos International Airport Fire Department", "spawn_coords": {"x": -1032.5, "y": -2384.0, "z": 14.1}},
    "BCFD": {"name": "Blaine County Fire Department", "spawn_coords": {"x": 1694.5, "y": 3587.0, "z": 35.6}},
    "PBFD": {"name": "Paleto Bay Fire Department", "spawn_coords": {"x": -379.0, "y": 6118.0, "z": 31.8}},
    "LSEMS": {"name": "Los Santos EMS", "spawn_coords": {"x": 307.7, "y": -1433.4, "z": 30.0}},
    "BCEMS": {"name": "Blaine County EMS", "spawn_coords": {"x": 1839.6, "y": 3672.9, "z": 34.3}},
    "PBEMS": {"name": "Paleto Bay EMS", "spawn_coords": {"x": -247.8, "y": 6329.2, "z": 32.4}}
};