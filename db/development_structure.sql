CREATE TABLE "account_requests" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255), "first_name" varchar(255), "last_name" varchar(255), "state" varchar(255), "activation_token" varchar(255), "approved_at" datetime, "declined_at" datetime, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "accounts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "balance" decimal(5,2) DEFAULT 0, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "daily_menu_items" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "day_of_week_id" integer, "menu_item_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "days_of_week" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255));
CREATE TABLE "days_off" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "starts_on" date, "ends_on" date, "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "menu_items" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "description" text, "price" decimal(5,2), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "ordered_menu_items" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "menu_item_id" integer, "order_id" integer, "quantity" integer, "total" decimal(5,2) DEFAULT 0, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "orders" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "served_on" date, "student_id" integer, "user_id" integer, "type" varchar(255), "grade" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "requested_students" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "account_request_id" integer, "first_name" varchar(255), "last_name" varchar(255), "grade" varchar(255));
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "students" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "account_id" integer, "first_name" varchar(255), "last_name" varchar(255), "grade" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "first_name" varchar(255), "last_name" varchar(255), "email" varchar(255) DEFAULT '' NOT NULL, "encrypted_password" varchar(128) DEFAULT '' NOT NULL, "reset_password_token" varchar(255), "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255), "roles_mask" integer, "account_id" integer, "preferred_grade" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE UNIQUE INDEX "index_days_of_week_on_name" ON "days_of_week" ("name");
CREATE UNIQUE INDEX "index_days_off_on_ends_on" ON "days_off" ("ends_on");
CREATE UNIQUE INDEX "index_days_off_on_starts_on" ON "days_off" ("starts_on");
CREATE UNIQUE INDEX "index_menu_items_on_name" ON "menu_items" ("name");
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE INDEX "index_users_on_first_name" ON "users" ("first_name");
CREATE INDEX "index_users_on_last_name" ON "users" ("last_name");
CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "users" ("reset_password_token");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20110511150950');

INSERT INTO schema_migrations (version) VALUES ('20110514215024');

INSERT INTO schema_migrations (version) VALUES ('20110517021237');

INSERT INTO schema_migrations (version) VALUES ('20110517024721');

INSERT INTO schema_migrations (version) VALUES ('20110531114523');

INSERT INTO schema_migrations (version) VALUES ('20110531120356');

INSERT INTO schema_migrations (version) VALUES ('20110531121058');

INSERT INTO schema_migrations (version) VALUES ('20110606110845');

INSERT INTO schema_migrations (version) VALUES ('20110620051649');

INSERT INTO schema_migrations (version) VALUES ('20110626185835');

INSERT INTO schema_migrations (version) VALUES ('20110711120635');