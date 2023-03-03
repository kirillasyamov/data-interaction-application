
CREATE TABLE IF NOT EXISTS rarity (
    id SMALLSERIAL PRIMARY KEY, 
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS property (
    id SMALLSERIAL PRIMARY KEY, 
    name TEXT UNIQUE NOT NULL, 
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS event (
    id SMALLSERIAL PRIMARY KEY, 
    name TEXT UNIQUE NOT NULL, 
    start_date DATE NOT NULL, 
    end_date DATE NOT NULL, 
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS race (
    id SMALLSERIAL PRIMARY KEY, 
    name TEXT UNIQUE NOT NULL, 
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS class (
    id SMALLSERIAL PRIMARY KEY, 
    name TEXT UNIQUE NOT NULL, 
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS role (
    id SMALLSERIAL PRIMARY KEY, 
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS account (
    id SERIAL PRIMARY KEY, 
    nickname VARCHAR(12) UNIQUE NOT NULL, 
    password VARCHAR(12) NOT NULL, 
    role_id SMALLINT NOT NULL, 
    class_id SMALLINT NOT NULL, 
    race_id SMALLINT NOT NULL,
    reg_date DATE NOT NULL,
    FOREIGN KEY (role_id) REFERENCES role(id),
    FOREIGN KEY (class_id) REFERENCES class(id),
    FOREIGN KEY (race_id) REFERENCES race(id)
);

CREATE TABLE IF NOT EXISTS session (
    id SERIAL PRIMARY KEY, 
    user_id INT NOT NULL, 
    kills SMALLINT DEFAULT(0), 
    deaths SMALLINT DEFAULT(0), 
    experience SMALLINT DEFAULT(0),  
    start_date_time TIMESTAMP DEFAULT(now()::timestamp(0)) NOT NULL, 
    end_date_time TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES account(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS party (
    id SERIAL PRIMARY KEY, 
    name TEXT UNIQUE NOT NULL, 
    leader_id INT, 
    FOREIGN KEY (leader_id) REFERENCES account(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS invitation (
    user_id INT, 
    party_id INT, 
    PRIMARY KEY (user_id, party_id), 
    FOREIGN KEY (user_id) REFERENCES account(id) ON DELETE CASCADE, 
    FOREIGN KEY (party_id) REFERENCES party(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS request (
    user_id INT, 
    party_id INT, 
    PRIMARY KEY (user_id, party_id), 
    FOREIGN KEY (user_id) REFERENCES account(id) ON DELETE CASCADE, 
    FOREIGN KEY (party_id) REFERENCES party(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS membership (
    party_id INT, 
    user_id INT, 
    PRIMARY KEY (party_id, user_id), 
    FOREIGN KEY (party_id) REFERENCES party(id) ON DELETE CASCADE, 
    FOREIGN KEY (user_id) REFERENCES account(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS penalty (
    id SMALLSERIAL PRIMARY KEY, 
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS ban (
    id SMALLSERIAL PRIMARY KEY, 
    penalty_id SMALLINT NOT NULL, 
    duration TIME, 
    description TEXT NOT NULL, 
    FOREIGN KEY (penalty_id) REFERENCES penalty(id)
);

CREATE TABLE IF NOT EXISTS reason (
    id SMALLSERIAL PRIMARY KEY, 
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS report_status (
    id SMALLSERIAL PRIMARY KEY,
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS report_on (
    id SERIAL PRIMARY KEY, 
    user_id INT NOT NULL, 
    reporter_id INT NOT NULL, 
    reason_id SMALLINT NOT NULL, 
    date DATE DEFAULT(now()::timestamp(0)) NOT NULL, 
    status_id SMALLINT, 
    FOREIGN KEY (user_id) REFERENCES account(id) ON DELETE CASCADE, 
    FOREIGN KEY (reporter_id) REFERENCES account(id) ON DELETE CASCADE, 
    FOREIGN KEY (status_id) REFERENCES report_status(id),
    FOREIGN KEY (reason_id) REFERENCES reason(id)
);

CREATE TABLE IF NOT EXISTS ban_user (
    id SERIAL PRIMARY KEY, 
    user_id INT NOT NULL, 
    ban_id SMALLINT NOT NULL, 
    date_time TIMESTAMP DEFAULT(now()::timestamp(0)) NOT NULL, 
    FOREIGN KEY (ban_id) REFERENCES ban(id), 
    FOREIGN KEY (user_id) REFERENCES account(id) ON DELETE SET NULL
); 

CREATE TABLE IF NOT EXISTS location (
    id SMALLSERIAL PRIMARY KEY, 
    name TEXT UNIQUE NOT NULL, 
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS coin (
    id SMALLSERIAL PRIMARY KEY, 
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS price (
    rarity_id SMALLINT, 
    coin_id SMALLINT, 
    cost SMALLINT NOT NULL, 
    PRIMARY KEY (rarity_id, coin_id), 
    FOREIGN KEY (rarity_id) REFERENCES rarity(id), 
    FOREIGN KEY (coin_id) REFERENCES coin(id)
);

CREATE TABLE IF NOT EXISTS merchant (
    id SMALLSERIAL PRIMARY KEY, 
    loc_id SMALLINT NOT NULL, 
    name TEXT UNIQUE NOT NULL, 
    description TEXT NOT NULL, 
    FOREIGN KEY (loc_id) REFERENCES location(id)
);

CREATE TABLE IF NOT EXISTS quest (
    id SMALLSERIAL PRIMARY KEY, 
    name TEXT UNIQUE NOT NULL, 
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS chest_type (
    id SMALLSERIAL PRIMARY KEY, 
    size SMALLINT NOT NULL, 
    displacement TIME NOT NULL, 
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS chest (
    id SMALLSERIAL PRIMARY KEY, 
    type_id SMALLINT NOT NULL, 
    loc_id SMALLINT NOT NULL, 
    FOREIGN KEY (type_id) REFERENCES chest_type(id), 
    FOREIGN KEY (loc_id) REFERENCES location(id) 
);

CREATE TABLE IF NOT EXISTS drop_rate (
    chest_type_id SMALLINT, 
    loot_rarity_id SMALLINT, 
    probability SMALLINT NOT NULL, 
    PRIMARY KEY (chest_type_id, loot_rarity_id), 
    FOREIGN KEY (chest_type_id) REFERENCES chest_type(id) ON DELETE CASCADE, 
    FOREIGN KEY (loot_rarity_id) REFERENCES rarity(id)
);

CREATE TABLE IF NOT EXISTS enemy (
    id SMALLSERIAL PRIMARY KEY, 
    name TEXT UNIQUE NOT NULL, 
    experience SMALLINT NOT NULL, 
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS enemy_location (
    enemy_id SMALLINT, 
    loc_id SMALLINT, 
    spawn_rate SMALLINT NOT NULL, 
    PRIMARY KEY (enemy_id, loc_id), 
    FOREIGN KEY (enemy_id) REFERENCES enemy(id) ON DELETE CASCADE, 
    FOREIGN KEY (loc_id) REFERENCES location(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS enemy_stat (
    enemy_id SMALLINT, 
    property_id SMALLINT, 
    value SMALLINT NOT NULL, 
    PRIMARY KEY (enemy_id, property_id), 
    FOREIGN KEY (enemy_id) REFERENCES enemy(id) ON DELETE CASCADE, 
    FOREIGN KEY (property_id) REFERENCES property(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS balance_upd (
    id SERIAL PRIMARY KEY, 
    user_id INT NOT NULL, 
    coin_id SMALLINT NOT NULL, 
    change SMALLINT NOT NULL NOT NULL, 
    date_time TIMESTAMP DEFAULT(now()::timestamp(0)) NOT NULL, 
    FOREIGN KEY (user_id) REFERENCES account(id) ON DELETE CASCADE, 
    FOREIGN KEY (coin_id) REFERENCES coin(id)
);

CREATE TABLE IF NOT EXISTS slot (
    id SMALLSERIAL PRIMARY KEY, 
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS armor_type (
    id SMALLSERIAL PRIMARY KEY, 
    name TEXT UNIQUE NOT NULL, 
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS armor_class (
    id SMALLSERIAL PRIMARY KEY, 
    name TEXT UNIQUE NOT NULL, 
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS weapon_class (
    id SMALLSERIAL PRIMARY KEY, 
    name TEXT UNIQUE NOT NULL, 
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS weapon_type (
    id SMALLSERIAL PRIMARY KEY, 
    name TEXT UNIQUE NOT NULL, 
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS skin (
    id SMALLSERIAL PRIMARY KEY, 
    name TEXT UNIQUE NOT NULL, 
    color_one VARCHAR(6) NOT NULL, 
    color_two VARCHAR(6) NOT NULL
);

CREATE OR REPLACE FUNCTION is_val (col_name INT) RETURNS INT AS $$ 
    DECLARE res INT; BEGIN 
        SELECT CASE WHEN col_name IS NOT NULL THEN 1 ELSE 0 END INTO res; 
        RETURN res;
    END; 
$$ LANGUAGE plpgsql STABLE;

CREATE OR REPLACE FUNCTION one_not_null (VARIADIC args INT[]) RETURNS BOOLEAN AS $$ 
    DECLARE x INT; num INT := 0; BEGIN 
        FOREACH x IN ARRAY args LOOP num := num + is_val(x); END LOOP; 
        RETURN num = 1; 
    END; 
$$ LANGUAGE plpgsql STABLE;

CREATE TABLE IF NOT EXISTS potion_detail (
    id SMALLSERIAL PRIMARY KEY, 
    rarity_id SMALLINT NOT NULL, 
    name TEXT UNIQUE NOT NULL, 
    description TEXT NOT NULL, 
    FOREIGN KEY (rarity_id) REFERENCES rarity(id)
);

CREATE TABLE IF NOT EXISTS treasure_detail (
    id SMALLSERIAL PRIMARY KEY, 
    rarity_id SMALLINT NOT NULL, 
    name TEXT UNIQUE NOT NULL, 
    description TEXT NOT NULL, 
    FOREIGN KEY (rarity_id) REFERENCES rarity(id)
);

CREATE TABLE IF NOT EXISTS resource_detail (
    id SMALLSERIAL PRIMARY KEY, 
    rarity_id SMALLINT NOT NULL, 
    name TEXT UNIQUE NOT NULL, 
    description TEXT NOT NULL, 
    FOREIGN KEY (rarity_id) REFERENCES rarity(id)
);

CREATE TABLE IF NOT EXISTS armor_detail (
    id SMALLSERIAL PRIMARY KEY, 
    rarity_id SMALLINT NOT NULL, 
    name TEXT UNIQUE NOT NULL, 
    class_id SMALLINT NOT NULL, 
    type_id SMALLINT NOT NULL, 
    skin_id SMALLINT NOT NULL, 
    description TEXT NOT NULL, 
    FOREIGN KEY (rarity_id) REFERENCES rarity(id), 
    FOREIGN KEY (skin_id) REFERENCES skin(id), 
    FOREIGN KEY (class_id) REFERENCES armor_class(id), 
    FOREIGN KEY (type_id) REFERENCES armor_type(id)
);

CREATE TABLE IF NOT EXISTS weapon_detail (
    id SMALLSERIAL PRIMARY KEY, 
    rarity_id SMALLINT NOT NULL, 
    name TEXT UNIQUE NOT NULL, 
    class_id SMALLINT NOT NULL, 
    type_id SMALLINT NOT NULL, 
    skin_id SMALLINT NOT NULL, 
    description TEXT NOT NULL, 
    FOREIGN KEY (rarity_id) REFERENCES rarity(id), 
    FOREIGN KEY (skin_id) REFERENCES skin(id), 
    FOREIGN KEY (class_id) REFERENCES weapon_class(id), 
    FOREIGN KEY (type_id) REFERENCES weapon_type(id)
);

CREATE TABLE IF NOT EXISTS recipe_detail (
    id SMALLSERIAL PRIMARY KEY, 
    rarity_id SMALLINT NOT NULL, 
    name TEXT UNIQUE NOT NULL, 
    item_id INT NOT NULL, 
    description TEXT NOT NULL, 
    FOREIGN KEY (rarity_id) REFERENCES rarity(id)
);

CREATE TABLE IF NOT EXISTS item (
    id SERIAL PRIMARY KEY, 
    resource_id SMALLINT, 
    recipe_id SMALLINT, 
    potion_id SMALLINT, 
    weapon_id SMALLINT, 
    armor_id SMALLINT, 
    treasure_id SMALLINT, 
    CONSTRAINT one_item_per_row CHECK (one_not_null(resource_id, recipe_id, potion_id, weapon_id, armor_id, treasure_id)), 
    FOREIGN KEY (resource_id) REFERENCES resource_detail(id) ON DELETE CASCADE, 
    FOREIGN KEY (recipe_id) REFERENCES recipe_detail(id) ON DELETE CASCADE, 
    FOREIGN KEY (potion_id) REFERENCES potion_detail(id) ON DELETE CASCADE, 
    FOREIGN KEY (weapon_id) REFERENCES weapon_detail(id) ON DELETE CASCADE, 
    FOREIGN KEY (armor_id) REFERENCES armor_detail(id) ON DELETE CASCADE, 
    FOREIGN KEY (treasure_id) REFERENCES treasure_detail(id) ON DELETE CASCADE
);

ALTER TABLE recipe_detail ADD CONSTRAINT recipe_detail_item_id_fkey FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS def_armor_stat (
    type_id SMALLINT, 
    class_id SMALLINT, 
    property_id SMALLINT, 
    def_value SMALLINT NOT NULL, 
    PRIMARY KEY (type_id, class_id, property_id), 
    FOREIGN KEY (type_id) REFERENCES armor_type(id), 
    FOREIGN KEY (class_id) REFERENCES armor_class(id), 
    FOREIGN KEY (property_id) REFERENCES property(id)
);

CREATE TABLE IF NOT EXISTS def_weapon_stat (
    type_id SMALLINT, 
    class_id SMALLINT, 
    property_id SMALLINT, 
    def_value SMALLINT NOT NULL, 
    PRIMARY KEY (type_id, class_id, property_id), 
    FOREIGN KEY (type_id) REFERENCES weapon_type(id) , 
    FOREIGN KEY (class_id) REFERENCES weapon_class(id), 
    FOREIGN KEY (property_id) REFERENCES property(id)
);

CREATE TABLE IF NOT EXISTS def_character_stat (
    race_id SMALLINT, 
    class_id SMALLINT,
    property_id SMALLINT, 
    def_value SMALLINT NOT NULL, 
    PRIMARY KEY (race_id, property_id, class_id), 
    FOREIGN KEY (class_id) REFERENCES class(id),
    FOREIGN KEY (race_id) REFERENCES race(id),
    FOREIGN KEY (property_id) REFERENCES property(id)
);

CREATE OR REPLACE FUNCTION create_res_uid() RETURNS trigger AS $$ 
    BEGIN 
        INSERT INTO item (resource_id) VALUES (NEW.id); 
        RETURN NULL; 
    END; 
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER on_res_insert AFTER INSERT ON resource_detail FOR EACH ROW EXECUTE PROCEDURE create_res_uid();

CREATE OR REPLACE FUNCTION create_rec_uid() RETURNS trigger AS $$ 
    BEGIN 
        INSERT INTO item(recipe_id) VALUES (NEW.id); 
        RETURN NULL; 
    END; 
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER on_rec_insert AFTER INSERT ON recipe_detail FOR EACH ROW EXECUTE PROCEDURE create_rec_uid();

CREATE OR REPLACE FUNCTION create_pot_uid() RETURNS trigger AS $$ 
    BEGIN 
        INSERT INTO item(potion_id) VALUES (NEW.id); 
        RETURN NULL; 
    END; 
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER on_pot_insert AFTER INSERT ON potion_detail FOR EACH ROW EXECUTE PROCEDURE create_pot_uid();

CREATE OR REPLACE FUNCTION create_weap_uid() RETURNS trigger AS $$ 
    BEGIN 
        INSERT INTO item(weapon_id) VALUES (NEW.id); 
        RETURN NULL; 
    END; 
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER on_weap_insert AFTER INSERT ON weapon_detail FOR EACH ROW EXECUTE PROCEDURE create_weap_uid();

CREATE OR REPLACE FUNCTION create_arm_uid() RETURNS trigger AS $$ 
    BEGIN 
        INSERT INTO item(armor_id) VALUES (NEW.id); 
        RETURN NULL; 
    END; 
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER on_arm_insert AFTER INSERT ON armor_detail FOR EACH ROW EXECUTE PROCEDURE create_arm_uid();

CREATE OR REPLACE FUNCTION create_treas_uid() RETURNS trigger AS $$ 
    BEGIN 
        INSERT INTO item(treasure_id) VALUES (NEW.id); 
        RETURN NULL; 
    END; 
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER on_treas_insert AFTER INSERT ON treasure_detail FOR EACH ROW EXECUTE PROCEDURE create_treas_uid();

CREATE TABLE IF NOT EXISTS discount (
    item_id INT, 
    event_id SMALLINT, 
    discount SMALLINT NOT NULL, 
    PRIMARY KEY (item_id, event_id), 
    FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE, 
    FOREIGN KEY (event_id) REFERENCES event(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS recipe_resource (
    recipe_id SMALLINT, 
    resource_id SMALLINT, 
    PRIMARY KEY (recipe_id, resource_id), 
    FOREIGN KEY (recipe_id) REFERENCES recipe_detail(id) ON DELETE CASCADE, 
    FOREIGN KEY (resource_id) REFERENCES resource_detail(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS potion_impact (
    potion_id SMALLINT, 
    property_id SMALLINT, 
    gain SMALLINT NOT NULL, 
    action_time TIME NOT NULL, 
    PRIMARY KEY (property_id, potion_id), 
    FOREIGN KEY (property_id) REFERENCES property(id) ON DELETE CASCADE, 
    FOREIGN KEY (potion_id) REFERENCES potion_detail(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS enemy_loot (
    enemy_id SMALLINT, 
    item_id SMALLINT, 
    drop_rate SMALLINT DEFAULT (50) NOT NULL, 
    PRIMARY KEY (enemy_id, item_id), 
    FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE, 
    FOREIGN KEY (enemy_id) REFERENCES enemy(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS merchant_offer (
    merchant_id SMALLINT, 
    item_id INT, 
    margin SMALLINT DEFAULT (40) NOT NULL, 
    PRIMARY KEY (merchant_id, item_id), 
    FOREIGN KEY (merchant_id) REFERENCES merchant(id) ON DELETE CASCADE, 
    FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS chest_loot (
    chest_id SMALLINT, 
    slot_id SMALLSERIAL, 
    item_id INT NOT NULL, 
    number SMALLINT DEFAULT (1) NOT NULL, 
    PRIMARY KEY (chest_id, slot_id), 
    FOREIGN KEY (chest_id) REFERENCES chest(id) ON DELETE CASCADE, 
    FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION check_no_overflow() RETURNS trigger AS $$ 
    DECLARE max_size INT; BEGIN 
        SELECT ct.size FROM chest_type ct JOIN chest c ON ct.id = c.type_id WHERE c.id = NEW.chest_id INTO max_size; 
        IF NEW.slot_id > max_size THEN 
            RAISE EXCEPTION 'THE CHEST IS FULL'; 
        END IF;
        RETURN NEW; 
    END; 
$$ LANGUAGE plpgsql STABLE;

CREATE OR REPLACE TRIGGER on_chest_loot_insert BEFORE INSERT ON chest_loot FOR EACH ROW EXECUTE PROCEDURE check_no_overflow();

CREATE TABLE IF NOT EXISTS dropped_item (
    id SERIAL PRIMARY KEY, 
    location_id SMALLINT NOT NULL, 
    item_id INT NOT NULL, 
    FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE, 
    FOREIGN KEY (location_id) REFERENCES location(id)
);

CREATE TABLE IF NOT EXISTS user_loot (
    user_id INT, 
    item_id INT, 
    slot_id SMALLINT,
    number SMALLINT DEFAULT (1) NOT NULL, 
    PRIMARY KEY (user_id, item_id), 
    FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE, 
    FOREIGN KEY (user_id) REFERENCES account(id) ON DELETE CASCADE, 
    FOREIGN KEY (slot_id) REFERENCES slot(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS quest_reward (
    quest_id SMALLINT, 
    item_id INT, 
    number SMALLINT DEFAULT(1) NOT NULL, 
    PRIMARY KEY (quest_id, item_id), 
    FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE, 
    FOREIGN KEY (quest_id) REFERENCES quest(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS npc_type (
    id SMALLSERIAL PRIMARY KEY, 
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS npc (
    id SMALLSERIAL PRIMARY KEY, 
    type_id SMALLINT NOT NULL, 
    race_id SMALLINT NOT NULL, 
    sex CHAR NOT NULL CHECK (sex LIKE 'm' OR sex LIKE 'f'), 
    age SMALLINT NOT NULL CHECK (age > 0), 
    name TEXT UNIQUE NOT NULL, 
    loc_id SMALLINT NOT NULL, 
    FOREIGN KEY (race_id) REFERENCES race(id) ON DELETE CASCADE, 
    FOREIGN KEY (loc_id) REFERENCES location(id) ON DELETE CASCADE, 
    FOREIGN KEY (type_id) REFERENCES npc_type(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS quest_npc (
    npc_id SMALLINT NOT NULL, 
    quest_id SMALLINT NOT NULL, 
    speech TEXT NOT NULL, 
    PRIMARY KEY (npc_id, quest_id), 
    FOREIGN KEY (npc_id) REFERENCES npc(id) ON DELETE CASCADE, 
    FOREIGN KEY (quest_id) REFERENCES quest(id) ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION get_user_id () RETURNS INT AS $$ 
    DECLARE client_id INT; BEGIN 
        SELECT user_id FROM temp INTO STRICT client_id;
        RETURN client_id; 
        EXCEPTION WHEN NO_DATA_FOUND THEN RAISE EXCEPTION 'AUTHENTICATION FAIL';
    END; 
$$ LANGUAGE plpgsql STABLE;

CREATE OR REPLACE FUNCTION get_session_id () RETURNS INT AS $$ 
    DECLARE client_session_id INT; BEGIN 
        SELECT session_id FROM temp INTO STRICT client_session_id;
        RETURN client_session_id; 
        EXCEPTION WHEN NO_DATA_FOUND THEN RAISE EXCEPTION 'AUTHENTICATION FAIL';
    END; 
$$ LANGUAGE plpgsql STABLE;

CREATE SCHEMA IF NOT EXISTS guest; 

CREATE ROLE guest WITH LOGIN;

GRANT USAGE ON SCHEMA guest TO guest;

CREATE OR REPLACE FUNCTION guest.registration (par_nickname VARCHAR(12), par_password VARCHAR(12), class_id INT, race_id INT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO account (role_id, nickname, password, class_id, race_id, reg_date) VALUES (1, $1, $2, $3, $4, current_date); 
        EXECUTE format('CREATE USER %I PASSWORD %L', par_nickname, par_password);
        EXECUTE format('GRANT player TO %I', par_nickname);
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION guest.authorization (name VARCHAR(12), pass VARCHAR(12)) RETURNS void AS $$ 
    DECLARE session_id INT; client_id INT; BEGIN 
        SELECT id FROM account WHERE nickname = name AND password = pass INTO STRICT client_id;
        CREATE TEMP TABLE IF NOT EXISTS temp (
            user_id INT, 
            session_id INT, 
            earned_deaths INT DEFAULT(0), 
            earned_kills INT DEFAULT(0), 
            earned_exp INT DEFAULT(0)
        ) ON COMMIT PRESERVE ROWS;
        SELECT nextval('session_id_seq') INTO session_id; 
        INSERT INTO session (id, user_id, start_date_time) VALUES (session_id, client_id, now()::timestamp(0)); 
        INSERT INTO temp VALUES (client_id, session_id);
        RETURN;
        EXCEPTION WHEN NO_DATA_FOUND THEN RAISE EXCEPTION 'USER NOT REGISTERED';
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER; 

CREATE SCHEMA IF NOT EXISTS player;

CREATE ROLE player WITH LOGIN;

GRANT guest TO player; 

GRANT USAGE ON SCHEMA player TO player;

CREATE OR REPLACE FUNCTION player.logout () RETURNS void AS $$ 
    DECLARE temp RECORD; BEGIN 
        SELECT * FROM temp INTO temp;
        UPDATE session SET kills = temp.earned_kills, deaths = temp.earned_deaths, experience = temp.earned_exp, end_date_time = current_date 
        WHERE id = temp.session_id;
        TRUNCATE TABLE temp;
        RETURN;
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.add_kills (added_kills INT) RETURNS void AS $$ 
    DECLARE temp_kills INT; BEGIN 
        SELECT earned_kills FROM temp INTO temp_kills;
        UPDATE temp SET earned_kills = temp_kills + added_kills;
        RETURN;
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.add_deaths (added_deaths INT) RETURNS void AS $$ 
    DECLARE temp_deaths INT; BEGIN 
        SELECT earned_deaths FROM temp INTO temp_deaths;
        UPDATE temp SET earned_deaths = temp_deaths + added_deaths;
        RETURN;
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.add_experience (added_exp INT) RETURNS void AS $$ 
    DECLARE temp_exp INT; BEGIN 
        SELECT earned_exp FROM temp INTO temp_exp;
        UPDATE temp SET earned_exp = temp_exp + added_exp;
        RETURN;
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.send_report (target_id INT, reason_id INT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO report_on (user_id, reporter_id, reason_id, date) VALUES ($1, (SELECT get_user_id()), $2, current_date); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.create_party (par_party_name TEXT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO party (name, leader_id) VALUES(par_party_name, (SELECT get_user_id())); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.delete_party (par_party_id INT) RETURNS void AS $$ 
    BEGIN 
        DELETE FROM party WHERE id = party_id AND leader_id = (SELECT get_user_id()); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_party_list () RETURNS SETOF party AS $$
    BEGIN 
        RETURN query SELECT * FROM party; 
    END; 
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_created_party_list () RETURNS SETOF party AS $$
    BEGIN 
        RETURN query SELECT * FROM party WHERE leader_id = (SELECT get_user_id()); 
    END; 
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_player_party_list () RETURNS SETOF party AS $$
    BEGIN 
        RETURN query SELECT * FROM party p JOIN membership m ON p.id = m.party_id WHERE m.user_id = (SELECT get_user_id()); 
    END; 
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_party_members (par_party_id INT) RETURNS TABLE (username VARCHAR(12)) AS $$ 
    BEGIN 
        RETURN query SELECT a.nickname FROM membership m JOIN account a ON m.user_id = a.id WHERE m.party_id = par_party_id; 
    END; 
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.send_party_request (par_party_id INT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO request (party_id, user_id) VALUES (par_party_id, (SELECT get_user_id())); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.send_party_invitation (par_party_id INT, par_user_id INT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO invitation (party_id, user_id) VALUES (par_party_id, par_user_id); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_invitations () RETURNS TABLE (party_name TEXT, members_num INT) AS $$ 
    BEGIN 
        RETURN QUERY WITH target_party AS (SELECT p.name, p.id 
        FROM invitation i 
        JOIN party p ON p.id = i.party_id WHERE i.user_id = (SELECT get_user_id())) 
        SELECT tp.name AS party_name, COUNT(m.user_id)::int AS members_num 
        FROM target_party tp 
        LEFT JOIN membership m ON tp.id = m.party_id GROUP BY tp.name; 
    END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_requests () RETURNS TABLE (party_name TEXT, nickname TEXT) AS $$ 
    BEGIN 
        RETURN QUERY WITH target_party AS (
            SELECT name, id FROM party WHERE leader_id = (SELECT get_user_id())
        ) SELECT tp.name, a.nickname::text FROM target_party tp 
        JOIN request r ON tp.id = r.party_id 
        JOIN account a ON r.user_id = a.id; 
    END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_invitations_num () RETURNS INT AS $$ 
    DECLARE num INT; BEGIN
        SELECT COUNT(*) FROM invitation WHERE user_id = (SELECT get_user_id()) INTO num; 
        RETURN num; 
    END; 
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_requests_num (par_party_id INT) RETURNS INT AS $$ 
    DECLARE num INT; BEGIN 
        SELECT COUNT(*) FROM request WHERE party_id = par_party_id INTO num; 
        RETURN num; 
    END; 
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.apply_request (par_target_id INT, par_party_id INT) RETURNS void AS $$ 
    DECLARE par_user_id INT; BEGIN 
        IF (SELECT get_user_id()) != (SELECT leader_id FROM party WHERE id = par_party_id) THEN
            RAISE EXCEPTION 'NO RIGHTS';
        END IF; 
        INSERT INTO membership (party_id, user_id) VALUES (par_party_id, par_target_id); 
        DELETE FROM request WHERE user_id = par_target_id AND party_id = par_party_id;
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.apply_invitation (par_party_id INT) RETURNS void AS $$ 
    DECLARE par_user_id INT; BEGIN
        SELECT get_user_id() INTO par_user_id;  
        INSERT INTO membership (party_id, user_id) VALUES (par_party_id, par_user_id); 
        DELETE FROM invitation WHERE user_id = par_user_id AND party_id = par_party_id;
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.reject_request (par_target_id INT, par_party_id INT) RETURNS void AS $$ 
    DECLARE par_user_id INT; BEGIN 
        IF (SELECT get_user_id()) != (SELECT leader_id FROM party WHERE id = par_party_id) THEN
            RAISE EXCEPTION 'NO RIGHTS';
        END IF; 
        DELETE FROM request WHERE user_id = par_target_id AND party_id = par_party_id;
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.reject_invitation (par_party_id INT) RETURNS void AS $$ 
    BEGIN 
        DELETE FROM invitation WHERE user_id = (SELECT get_user_id()) AND party_id = par_party_id;
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_balance () RETURNS INT[][] AS $$ 
    DECLARE coin RECORD; par_balance INT; par_balance_arr INT[][]; BEGIN
        FOR coin IN SELECT id FROM coin LOOP 
            SELECT SUM(change) FROM balance_upd WHERE coin_id = coin.id AND user_id = (SELECT get_user_id()) INTO par_balance;
            IF par_balance IS NULL THEN
                par_balance := 0;
            END IF;
            par_balance_arr := par_balance_arr || ARRAY[[coin.id, par_balance]];
        END LOOP; 
        RETURN par_balance_arr;
    END;  
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.add_balance_upd (par_coin_id INT, par_change INT) RETURNS void AS $$ 
    BEGIN
        INSERT INTO balance_upd (user_id, coin_id, change) VALUES ((SELECT get_user_id()), par_coin_id, par_change);
        RETURN; 
    END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_merchant_offers (par_merchant_id INT) RETURNS SETOF INT AS $$ 
    BEGIN
        RETURN query SELECT item_id FROM merchant_offer WHERE merchant_id = par_merchant_id;
    END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_new () RETURNS SETOF item AS $$ 
    BEGIN 
        RETURN query SELECT * FROM item ORDER BY id DESC LIMIT 10; 
    END; 
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_online () RETURNS INT AS $$ 
    DECLARE number INT; BEGIN 
        SELECT COUNT(*) FROM pg_stat_activity WHERE state = 'active' AND datname = 'server' INTO number; 
        RETURN number; 
    END; 
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_stats () RETURNS TABLE (rating INT, kd INT, exp INT, nickname VARCHAR(12)) AS $$ 
    BEGIN 
        RETURN QUERY WITH subquery AS (
            SELECT sum(s.kills) - sum(s.deaths) AS kd, SUM(s.experience) AS exp, a.nickname 
            FROM session s 
            JOIN account a ON s.user_id = a.id 
            GROUP BY a.nickname
        ) SELECT (ROW_NUMBER () OVER (ORDER BY subquery.exp DESC))::int as rating, subquery.kd::int, subquery.exp::int, subquery.nickname FROM subquery; 
    END; 
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_personal_stats () RETURNS TABLE (rating INT, kd INT, exp INT) AS $$ 
    DECLARE par_nickname VARCHAR(12); BEGIN 
        SELECT nickname FROM account WHERE id = (SELECT get_user_id()) INTO par_nickname;
        RETURN QUERY SELECT s.rating, s.kd, s.exp FROM player.get_stats () s WHERE s.nickname = par_nickname; 
    END; 
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_char_stats () RETURNS TABLE (property TEXT, value SMALLINT) AS $$
    BEGIN
        RETURN QUERY WITH subquery AS (
            SELECT class_id, race_id FROM account
            WHERE id = (SELECT get_user_id()) 
        ) SELECT p.name AS property, cs.def_value FROM subquery sub
        JOIN def_character_stat cs ON cs.race_id = sub.race_id AND cs.class_id = sub.class_id
        JOIN property p ON cs.property_id = p.id;
    END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_spent_time () RETURNS TIME AS $$ 
    DECLARE par_spent_time TIME; BEGIN
        SELECT SUM(start_date_time - end_date_time) FROM session WHERE user_id = (SELECT get_user_id()) AND end_date_time IS NOT NULL INTO par_spent_time;
        IF par_spent_time IS NULL THEN 
            RETURN '00:00:00';
        END IF;
        RETURN par_spent_time;
    END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_kills () RETURNS INT AS $$ 
    DECLARE par_kills INT; BEGIN
        SELECT SUM(kills) FROM session WHERE user_id = (SELECT get_user_id()) INTO par_kills;
        IF par_kills IS NULL THEN 
            RETURN 0;
        END IF;
        RETURN par_kills;
    END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_deaths () RETURNS INT AS $$ 
    DECLARE par_deaths INT; BEGIN
        SELECT SUM(deaths) FROM session WHERE user_id = (SELECT get_user_id()) INTO par_deaths;
        IF par_deaths IS NULL THEN 
            RETURN 0;
        END IF;
        RETURN par_deaths;
    END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_experience () RETURNS INT AS $$ 
    DECLARE par_exp INT; BEGIN
        SELECT SUM(experience) FROM session WHERE user_id = (SELECT get_user_id()) INTO par_exp;
        IF par_exp IS NULL THEN 
            RETURN 0;
        END IF;
        RETURN par_exp;
    END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_weapon_detail (par_item_id INT) RETURNS TABLE (rarity TEXT, name TEXT, class TEXT, type TEXT, description TEXT) AS $$
    BEGIN
        RETURN query SELECT r.name AS rarity, wd.name as name, wc.name AS class, wt.name AS type, wd.description 
            FROM weapon_detail wd
            JOIN rarity r ON wd.rarity_id = r.id
            JOIN weapon_class wc ON wd.class_id = wc.id
            JOIN weapon_type wt ON wd.type_id = wt.id
            WHERE wd.id = par_item_id;
    END;  
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_weapon_stats (par_weapon_det_id INT) RETURNS TABLE (property TEXT, value SMALLINT) AS $$
    BEGIN
        RETURN QUERY WITH subquery AS (
            SELECT class_id, type_id FROM weapon_detail
            WHERE id = par_weapon_det_id
        ) SELECT p.name AS property, ws.def_value FROM subquery sub
        JOIN def_weapon_stat ws ON ws.type_id = sub.type_id AND ws.class_id = sub.class_id
        JOIN property p ON ws.property_id = p.id;
    END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_armor_detail (par_item_id INT) RETURNS TABLE (rarity TEXT, name TEXT, class TEXT, type TEXT, description TEXT) AS $$
    BEGIN
        RETURN query SELECT r.name AS rarity, ad.name as name, ac.name AS class, at.name AS type, ad.description 
            FROM armor_detail ad
            JOIN rarity r ON ad.rarity_id = r.id
            JOIN armor_class ac ON ad.class_id = ac.id
            JOIN armor_type at ON ad.type_id = at.id
            WHERE ad.id = par_item_id;
    END;  
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_armor_stats (par_armor_det_id INT) RETURNS TABLE (property TEXT, value SMALLINT) AS $$
    BEGIN
        RETURN QUERY WITH subquery AS (
            SELECT class_id, type_id FROM armor_detail
            WHERE id = par_armor_det_id
        ) SELECT p.name AS property, arms.def_value FROM subquery sub
        JOIN def_weapon_stat arms ON arms.type_id = sub.type_id AND arms.class_id = sub.class_id
        JOIN property p ON arms.property_id = p.id;
    END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_resource_detail (par_item_id INT) RETURNS TABLE (rarity TEXT, name TEXT, description TEXT) AS $$
    BEGIN
        RETURN query SELECT r.name AS rarity, rd.name as name, rd.description 
            FROM resource_detail rd
            JOIN rarity r ON rd.rarity_id = r.id
            WHERE rd.id = par_item_id;
    END;  
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_recipe_detail (par_item_id INT) RETURNS TABLE (rarity TEXT, name TEXT, description TEXT) AS $$
    BEGIN
        RETURN query SELECT r.name AS rarity, rd.name as name, rd.description 
            FROM recipe_detail rd
            JOIN rarity r ON rd.rarity_id = r.id
            WHERE rd.id = par_item_id;
    END;  
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_recipe_ingredients (par_recipe_det_id INT) RETURNS TABLE (ingredient TEXT) AS $$
    BEGIN
        RETURN QUERY SELECT rsd.name FROM resource_detail rsd 
        JOIN recipe_resource rc ON rsd.id = rc.resource_id
        WHERE rc.recipe_id = par_recipe_det_id;
    END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_treasure_detail (par_item_id INT) RETURNS TABLE (rarity TEXT, name TEXT, description TEXT) AS $$
    BEGIN
        RETURN query SELECT r.name AS rarity, td.name as name, td.description 
            FROM treasure_detail td
            JOIN rarity r ON td.rarity_id = r.id
            WHERE td.id = par_item_id;
    END;  
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_potion_detail (par_item_id INT) RETURNS TABLE (rarity TEXT, name TEXT, description TEXT) AS $$
    BEGIN
        RETURN query SELECT r.name AS rarity, pd.name as name, pd.description 
            FROM potion_detail pd
            JOIN rarity r ON pd.rarity_id = r.id
            WHERE pd.id = par_item_id;
    END;  
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_potion_impacts (par_potion_det_id INT) RETURNS TABLE (property TEXT, gain SMALLINT, action_time TIME) AS $$
    BEGIN
        RETURN QUERY SELECT prop.name AS property, pi.gain, pi.action_time FROM potion_impact pi
        JOIN property prop ON prop.id = pi.property_id 
        WHERE pi.potion_id = par_potion_det_id;
    END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.check_ban () RETURNS TABLE (duration TIME, waiting_time TIME, description TEXT) AS $$ 
    BEGIN 
        RETURN QUERY WITH subquery AS (
            SELECT b.duration, bu.date_time - now()::timestamp(0) + b.duration AS waiting, b.description 
                FROM ban_user bu 
                JOIN ban b ON bu.ban_id = b.id 
                WHERE bu.user_id = (SELECT get_user_id()) AND bu.date_time + b.duration > now()::timestamp(0)
            ) SELECT subquery.duration, subquery.waiting, subquery.description FROM subquery; 
    END; 
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_inventory () RETURNS TABLE (item_id INT, slot_id SMALLINT, number SMALLINT) AS $$ 
    BEGIN 
        RETURN QUERY SELECT ul.item_id, ul.slot_id, ul.number FROM user_loot ul 
        WHERE ul.user_id = (SELECT get_user_id()); 
    END; 
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_equipment () RETURNS TABLE (item_id INT, slot_id SMALLINT) AS $$ 
    BEGIN 
        RETURN QUERY SELECT ul.item_id, ul.slot_id FROM user_loot ul 
        WHERE ul.user_id = (SELECT get_user_id()) AND ul.slot_id IS NOT NULL; 
    END; 
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_item_by_slot (par_slot_id INT) RETURNS INT AS $$
    DECLARE par_item_id INT; BEGIN
        SELECT item_id FROM user_loot WHERE slot_id = par_slot_id AND user_id = (SELECT get_user_id()) INTO par_item_id;
        RETURN par_item_id;
    END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.get_slot_by_item (par_item_id INT) RETURNS INT AS $$
    DECLARE par_slot_id INT; BEGIN
        SELECT slot_id FROM user_loot WHERE item_id = par_item_id AND user_id = (SELECT get_user_id()) INTO par_slot_id;
        RETURN par_slot_id;
    END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.move_item (par_item_id INT, par_slot_id INT) RETURNS void AS $$ 
    DECLARE par_user_id INT; BEGIN
        SELECT get_user_id () INTO par_user_id;
        UPDATE user_loot SET slot_id = NULL WHERE user_id = par_user_id AND slot_id = par_slot_id; 
        UPDATE user_loot SET slot_id = par_slot_id WHERE user_id = par_user_id AND item_id = par_item_id; 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION player.delete_item (par_item_id iNT) RETURNS void AS $$ 
    BEGIN 
        UPDATE user_loot SET number = number - 1 WHERE user_id = (SELECT get_user_id()) AND item_id = par_item_id; 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION check_item_loss() RETURNS trigger AS $$ 
    BEGIN 
        IF NEW.number = 0 THEN 
            DELETE FROM user_loot WHERE user_id = NEW.user_id AND item_id = NEW.item_id; 
            RETURN NULL;
        END IF; 
        RETURN NEW; 
    END; 
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER on_item_update BEFORE UPDATE ON user_loot FOR EACH ROW EXECUTE PROCEDURE check_item_loss(); 

CREATE SCHEMA IF NOT EXISTS admin; 

CREATE ROLE admin WITH LOGIN;

GRANT player TO admin;

GRANT USAGE ON SCHEMA admin TO admin;

CREATE OR REPLACE FUNCTION admin.add_skin (par_name TEXT, par_color_one VARCHAR(6), par_color_two VARCHAR(6)) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO skin (name, color_one, color_two) VALUES ($1, $2, $3); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_weapon (par_class_id INT, par_type_id INT, par_skin_id INT, par_rarity_id INT, par_name TEXT, par_description TEXT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO weapon_detail (class_id, type_id, skin_id, rarity_id, name, description) VALUES ($1, $2, $3, $4, $5, $6); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_armor (par_class_id INT, par_type_id INT, par_skin_id INT, par_rarity_id INT, par_name TEXT, par_description TEXT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO armor_detail (class_id, type_id, skin_id, rarity_id, name, description) VALUES ($1, $2, $3, $4, $5, $6); 
    RETURN; 
END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_recipe (par_rarity_id INT, par_target_item_id INT, par_name TEXT, par_description TEXT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO recipe_detail (rarity_id, item_id, name, description) VALUES ($1, $2, $3, $4); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_resource (par_rarity_id INT, par_name TEXT, par_description TEXT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO resource_detail (rarity_id, name, description) VALUES ($1, $2, $3); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_recipe_resource (par_recipe_id INT, par_resource_id INT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO recipe_resource (recipe_id, resource_id) VALUES ($1, $2); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_potion (par_rarity_id INT, par_name TEXT, par_description TEXT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO potion_detail (rarity_id, name, description) VALUES ($1, $2, $3); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_treasure (par_rarity_id INT, par_name TEXT, par_description TEXT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO treasure_detail (rarity_id, name, description) VALUES ($1, $2, $3); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_event (par_name TEXT, par_start_date DATE, par_end_date DATE, par_description TEXT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO event (name, start_date, end_date, description) VALUES ($1, $2, $3, $4); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE FUNCTION admin.add_discount (par_item_id INT, par_event_id INT, par_discount INT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO discount (item_id, event_id, discount) VALUES ($1, $2, $3); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_npc (par_type_id INT, par_race INT, par_sex CHAR, par_age INT, par_name TEXT, par_loc_id INT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO npc (type_id, race_id, sex, age, name, loc_id) VALUES ($1, $2, $3, $4, $5, $6); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER; 

CREATE OR REPLACE FUNCTION admin.add_quest (par_name TEXT, par_description TEXT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO quest (name, description) VALUES ($1, $2); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_npc_quest (par_npc_id INT, par_quest_id INT, par_speech TEXT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO quest_npc (npc_id, quest_id, speech) VALUES ($1, $2, $3); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_merchant (par_loc_id INT, par_name TEXT, par_description TEXT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO merchant (loc_id, name, description) VALUES ($1, $2, $3); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_chest (par_loc_id INT, par_type_id INT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO chest (loc_id, type_id) VALUES ($1, $2); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_merchant_offer (par_merchant_id INT, par_item_id INT, par_margin INT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO merchant_offer (merchant_id, item_id, margin) VALUES ($1, $2, $3); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_quest_reward (par_quest_id INT, par_item_id INT, par_number INT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO quest_reward (quest_id, item_id, number) VALUES ($1, $2, $3); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_chest_loot (par_chest_id INT, par_slot_id INT, par_item_id INT, par_number INT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO chest_loot (chest_id, slot_id, item_id, number) VALUES ($1, $2, $3, $4); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_enemy_loot (par_enemy_id INT, par_item_id INT, par_drop_rate INT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO enemy_loot (enemy_id, item_id, drop_rate) VALUES ($1, $2, $3); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_dropped_item (par_loc_id INT, par_item_id INT) RETURNS void AS $$ 
    BEGIN 
        INSERT INTO dropped_item (location_id, item_id) VALUES ($1, $2); 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.change_price (par_rarity_id INT, par_coin_id INT, par_cost INT) RETURNS void AS $$ 
    BEGIN 
        UPDATE price SET cost = par_cost WHERE rarity_id = par_rarity_id AND coin_id = par_coin_id; 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.change_enemy_spawn_rate (par_enemy_id INT, par_loc_id INT, par_spawn_rate INT) RETURNS void AS $$ 
    BEGIN 
        UPDATE enemy_location SET spawn_rate = par_spawn_rate WHERE enemy_id = par_enemy_id AND loc_id = par_loc_id; 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE FUNCTION admin.del_recipe_resource (par_recipe_id INT, par_resource_id INT) RETURNS void AS $$ 
    BEGIN 
        DELETE FROM recipe_resource WHERE recipe_id = par_recipe_id AND resource_id = par_resource_id; 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.delete_chest (par_chest_id INT) RETURNS void AS $$ 
    BEGIN 
        DELETE FROM chest WHERE id = par_chest_id; 
        RETURN; 
    END; 
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.get_npc_total_number () RETURNS INT AS $$ 
    DECLARE number INT; BEGIN 
        SELECT COUNT(id) FROM npc INTO number; 
        RETURN number; 
    END; 
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.get_npc_number (par_loc_id INT) RETURNS INT AS $$ 
    DECLARE number INT; BEGIN 
        SELECT COUNT(id) FROM npc WHERE loc_id = par_loc_id GROUP BY loc_id INTO number; 
        RETURN number; 
    END; 
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.get_npc_detail (par_npc_id INT) RETURNS table (name TEXT, sex CHAR, age SMALLINT, location TEXT, npc_type TEXT, npc_race TEXT) AS $$ 
    BEGIN 
        RETURN QUERY SELECT n.name, n.sex, n.age, l.name AS location, nt.description AS npc_type, r.name AS npc_race 
        FROM npc n 
        JOIN npc_type nt ON n.type_id = nt.id 
        JOIN location l ON l.id = n.loc_id 
        JOIN race r ON r.id = n.race_id 
        WHERE n.id = par_npc_id; 
    END; 
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.change_report_status (par_user_id INT, par_reason_id INT, par_status_id INT) RETURNS void AS $$
    BEGIN
        UPDATE report_on SET status_id = par_status_id WHERE user_id = par_user_id AND reason_id = par_reason_id;
        RETURN;
    END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.add_ban_user (par_user_id INT, par_ban_id INT) RETURNS void AS $$
    BEGIN
        INSERT INTO ban_user (user_id, ban_id, date_time) VALUES ($1, $2, now()::timestamp(0));
    END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION get_start (par_end DATE, par_interval TEXT) RETURNS DATE AS $$ 
    DECLARE par_start DATE; BEGIN 
        CASE par_interval
            WHEN 'day' THEN 
                par_start := (par_end - INTERVAL '1 month')::date;
            WHEN 'month' THEN
                par_start := (par_end - INTERVAL '1 year')::date;
            WHEN 'year' THEN 
                par_start := (par_end - INTERVAL '100 year')::date;
            ELSE 
                RAISE EXCEPTION 'WRONG INTERVAL';
        END CASE;
        RETURN par_start;
    END;
$$ LANGUAGE plpgsql IMMUTABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.get_b_upd_record (par_interval TEXT, par_coin_id INT, par_end DATE) RETURNS TABLE (total INT, period INT) AS $$ 
    #variable_conflict use_column
    DECLARE par_start DATE; BEGIN
        SELECT get_start(par_end, par_interval) INTO par_start;
        RETURN QUERY WITH subquery AS (
            SELECT change, coin_id, date_part(par_interval, date_time)::int AS period FROM balance_upd
            WHERE date_time BETWEEN par_start AND par_end
            ) SELECT SUM(ABS(change))::int AS total, period FROM subquery WHERE coin_id = par_coin_id GROUP BY period;
    END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.get_total_acc_record (par_interval TEXT, par_end DATE) RETURNS TABLE (total INT, period INT) AS $$ 
    #variable_conflict use_column
    DECLARE par_start DATE; BEGIN
        SELECT get_start(par_end, par_interval) INTO par_start;
        RETURN QUERY WITH subquery AS (
            SELECT id, date_part(par_interval, reg_date)::int AS period FROM account
            WHERE reg_date BETWEEN par_start AND par_end
            ) SELECT MAX(id)::int AS total, period FROM subquery GROUP BY period;
    END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION admin.get_new_acc_record (par_interval TEXT, par_end DATE) RETURNS TABLE (total INT, period INT) AS $$ 
    #variable_conflict use_column
    DECLARE par_start DATE; BEGIN
        SELECT get_start(par_end, par_interval) INTO par_start;
        RETURN QUERY WITH subquery AS (
            SELECT id, date_part(par_interval, reg_date)::int AS period FROM account
            WHERE reg_date BETWEEN par_start AND par_end 
            ) SELECT COUNT(*)::int AS total, period FROM subquery GROUP BY period;
    END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;