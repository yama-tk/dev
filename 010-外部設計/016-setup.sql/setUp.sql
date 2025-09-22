--* シーケンスの作成 **************************--

-- シーケンスのリセット
DROP SEQUENCE IF EXISTS users_user_num_seq;
DROP SEQUENCE IF EXISTS categories_category_id_seq;
DROP SEQUENCE IF EXISTS colors_color_id_seq;
DROP SEQUENCE IF EXISTS items_item_id_seq;
DROP SEQUENCE IF EXISTS payments_payment_id_seq;
DROP SEQUENCE IF EXISTS histories_history_id_seq;

-- 会員番号のシーケンスの作成
CREATE SEQUENCE users_user_num_seq
	START WITH 100001 -- 開始値:100,001
	INCREMENT BY 1    -- 増分値:1
	MAXVALUE 999999   -- 最大値:999,999
	NO CYCLE          -- 最大値に達した場合エラーを出力
;

-- カテゴリIDのシーケンスの作成
CREATE SEQUENCE categories_category_id_seq
	START WITH 101    -- 開始値:101
	INCREMENT BY 1    -- 増分値:1
	MAXVALUE 999      -- 最大値:999
	NO CYCLE          -- 最大値に達した場合エラーを出力
;

-- カラーIDのシーケンスの作成
CREATE SEQUENCE colors_color_id_seq
	START WITH 101    -- 開始値:101
	INCREMENT BY 1    -- 増分値:1
	MAXVALUE 999      -- 最大値:999
	NO CYCLE          -- 最大値に達した場合エラーを出力
;

-- 商品IDのシーケンスの作成
CREATE SEQUENCE items_item_id_seq
	START WITH 100001 -- 開始値:100,001
	INCREMENT BY 1    -- 増分値:1
	MAXVALUE 999999   -- 最大値:999,999
	NO CYCLE          -- 最大値に達した場合エラーを出力
;

-- 支払い方法IDのシーケンスの作成
CREATE SEQUENCE payments_payment_id_seq
	START WITH 101    -- 開始値:101
	INCREMENT BY 1    -- 増分値:1
	MAXVALUE 999      -- 最大値:999
	NO CYCLE          -- 最大値に達した場合エラーを出力
;

-- 履歴IDのシーケンスの作成
CREATE SEQUENCE histories_history_id_seq
	START WITH 1      -- 開始値:1
	INCREMENT BY 1    -- 増分値:1
	MAXVALUE 99999999 -- 最大値:99,999,999
	NO CYCLE          -- 最大値に達した場合エラーを出力
;


--* テーブルの作成 ******************************************--

-- テーブルにリセット
DROP TABLE IF EXISTS history_details;
DROP TABLE IF EXISTS histories;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS items_in_cart;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS colors;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;


-- 会員テーブルの作成
CREATE TABLE users (
	user_num INTEGER NOT NULL,
	user_name VARCHAR(255) NOT NULL,
	user_id VARCHAR(255) UNIQUE NOT NULL,
	password VARCHAR(255) NOT NULL,
	address VARCHAR(255) NOT NULL,
	is_withdraw BOOLEAN NOT NULL DEFAULT FALSE,
	withdrew_at DATE DEFAULT NULL,
	withdrew_id VARCHAR(255) DEFAULT NULL,
	
	-- 主キー
	PRIMARY KEY (user_num)
);

-- カテゴリテーブルの作成
CREATE TABLE categories (
	category_id INTEGER NOT NULL,
	category_name VARCHAR(255) NOT NULL,
	
	-- 主キー
	PRIMARY KEY (category_id)
);

-- カラーテーブルの作成
CREATE TABLE colors (
	color_id INTEGER NOT NULL,
	color_name VARCHAR(255) NOT NULL,
	
	-- 主キー
	PRIMARY KEY (color_id)
);

-- 商品テーブルの作成
CREATE TABLE items (
	item_id INTEGER NOT NULL,
	item_name VARCHAR(255) NOT NULL,
	category_id INTEGER NOT NULL,
	price INTEGER NOT NULL,
	color_id INTEGER NOT NULL,
	shop VARCHAR(255) NOT NULL,
	stock INTEGER NOT NULL,
	is_recommend BOOLEAN NOT NULL DEFAULT FALSE,
	
	-- 主キー
	PRIMARY KEY (item_id),
	
	-- 外部キー
	FOREIGN KEY (category_id) 
		REFERENCES categories (category_id),
	FOREIGN KEY (color_id) 
		REFERENCES colors (color_id)
);

-- カートテーブルの作成
CREATE TABLE items_in_cart (
	user_num INTEGER NOT NULL,
	item_id INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	
	-- 主キー
	PRIMARY KEY (user_num,item_id),
	
	-- 外部キー
	FOREIGN KEY (user_num) 
		REFERENCES users (user_num),
	FOREIGN KEY (item_id) 
		REFERENCES items (item_id)
);

-- 支払い方法テーブルの作成
CREATE TABLE payments (
	payment_id INTEGER NOT NULL,
	payment_name VARCHAR(255) NOT NULL,
	
	-- 主キー
	PRIMARY KEY (payment_id)
);

-- 履歴ヘッダテーブル
CREATE TABLE histories (
	history_id INTEGER NOT NULL,
	user_num INTEGER NOT NULL,
	purchased_at DATE NOT NULL,
	address VARCHAR(255) NOT NULL,
	payment_id INTEGER NOT NULL,
	is_cancel BOOLEAN NOT NULL DEFAULT FALSE,
	canceled_at DATE DEFAULT NULL,
	
	-- 主キー
	PRIMARY KEY (history_id),
	
	-- 外部キー
	FOREIGN KEY (user_num) 
		REFERENCES users (user_num),
	FOREIGN KEY (payment_id) 
		REFERENCES payments (payment_id)
);

-- 履歴詳細テーブル
CREATE TABLE history_details (
	history_id INTEGER NOT NULL,
	item_id INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	
	-- 主キー
	PRIMARY KEY (history_id,item_id),
	
	-- 外部キー
	FOREIGN KEY (history_id) 
		REFERENCES histories (history_id),
	FOREIGN KEY (item_id) 
		REFERENCES items (item_id)
);


--* 初期レコードの設定 ******************************--

-- 会員テーブルの初期レコード
INSERT INTO users (user_num, user_name, user_id, password, address)
	VALUES (nextval('users_user_num_seq'), 'DIS太郎', 'distaro@example.com', 'distaro001', '東京都渋谷区恵比寿1-1-1'),
		   (nextval('users_user_num_seq'), '山田第一子', 'daiichi@example.com', 'daiichi002', '埼玉県さいたま市中央区1-1-1'),
		   (nextval('users_user_num_seq'), '戦略本夫', 'senryakaku@example.com', 'senryaku003', '沖縄県那覇市1-1-1');
		  
-- カテゴリテーブルの初期レコード
INSERT INTO categories (category_id, category_name) 
	VALUES (nextval('categories_category_id_seq'), '帽子'),
	       (nextval('categories_category_id_seq'), '鞄');
			  
-- カラーテーブルの初期レコード
INSERT INTO colors (color_id, color_name) 
	VALUES (nextval('colors_color_id_seq'), '赤'),
	       (nextval('colors_color_id_seq'), '黄');
		  
-- 商品テーブルの初期レコード
INSERT INTO items (item_id, item_name, category_id, price, color_id, shop, stock, is_recommend)
	VALUES (nextval('items_item_id_seq'), '麦わら帽子', 101, 3200, 101, '赤髪帽子協会', 42, true),
	       (nextval('items_item_id_seq'), '革の鞄', 102, 5500, 101, 'スキンバッグス', 15, false),
		   (nextval('items_item_id_seq'), '黄金の麦わら帽子', 101, 12000, 102, 'ゴールドレジェンド', 2, false);
		   
-- 支払い方法テーブルの初期レコード
INSERT INTO payments (payment_id, payment_name) 
	VALUES (nextval('payments_payment_id_seq'), '代金引換');


