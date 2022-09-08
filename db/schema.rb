# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0] do
  create_table 'core.App', primary_key: 'authorID', force: :cascade do |t|
    t.bigint 'appID'
    t.string 'name', null: false
    t.text 'description'
    t.string 'lang'
    t.bigint 'authorID'
    t.string 'pageURL', null: false
    t.bigint 'byteSize', null: false
    t.string 'iconURL', null: false
    t.string 'colorBg'
    t.string 'colorTheme'
    t.boolean 'promoted', default: false, null: false
    t.index ['authorID'], name: 'index_App_on_authorID'
    t.index ['pageURL'], name: 'index_App_on_pageURL'
  end

  create_table 'Author', id: false, force: :cascade do |t|
    t.bigint 'authorID', null: false
    t.string 'name', null: false
  end

  create_table 'Review', primary_key: 'appID', force: :cascade do |t|
    t.bigint 'reviewID', null: false
    t.bigint 'appID', null: false
    t.string 'ip', null: false
    t.integer 'rating', null: false
    t.text 'body'
    t.date 'date', default: -> { 'CURRENT_DATE' }, null: false
    t.index ['appID'], name: 'index_Review_on_appID'
  end
end
