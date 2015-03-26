#include "pebble.h"
#include "main.h"

#define NUM_MENU_SECTIONS 2
uint16_t num_of_items = 0;
bool no_items;

//How many sections
static uint16_t menu_get_num_sections_callback(MenuLayer *menu_layer, void *data){
    return NUM_MENU_SECTIONS;
}

//how many items per section
static uint16_t menu_get_num_rows_callback(MenuLayer *menu_layer, uint16_t section_index, void *data){
    switch (section_index) {
        case 0:
            return num_of_items;
        case 1:
            return 1;
        default:
            return 0;
    }
}

//Height of menu
static int16_t menu_get_header_height_callback(MenuLayer *menu_layer, uint16_t section_index, void *data){
    return MENU_CELL_BASIC_HEADER_HEIGHT;
}

//Fill in section titles
static void menu_draw_header_callback(GContext* ctx, const Layer *cell_layer, uint16_t section_index, void *data){
    switch (section_index) {
        case 0:
            // Draw title text in the section header
            menu_cell_basic_header_draw(ctx, cell_layer, "Decks");
            break;
        case 1:
            menu_cell_basic_header_draw(ctx, cell_layer, "Add New Deck");
            break;
    }
}

//Display meny items
static void menu_draw_row_callback(GContext* ctx, const Layer *cell_layer, MenuIndex *cell_index, void *data){
    if(no_items == true){   //if there are no decks
        switch(cell_index->section){
            case 0:
                switch(cell_index->row){
                    case 0:
                        menu_cell_title_draw(ctx, cell_layer, "No Decks");
                        break;
                }
                break;
            case 1:
                switch (cell_index->row) {
                    case 0:
                        // There is title draw for something more simple than a basic menu item
                        menu_cell_basic_draw(ctx, cell_layer, "Add Deck", "From phone app", NULL);
                        break;
                }
                break;
        }
    }
    else
    {
        switch(cell_index->section){
            case 0:
                switch(cell_index->row){
                    case 0:
                        menu_cell_title_draw(ctx, cell_layer, "Deck");
                        break;
                }
                break;
            case 1:
                switch (cell_index->row) {
                    case 0:
                        // There is title draw for something more simple than a basic menu item
                        menu_cell_basic_draw(ctx, cell_layer, "Add Deck", "From phone app", NULL);
                        break;
                }
                break;
        }

    }
}

//Received deck from iOS
/*
 TODO:
 add prompt that asks if user would like to add deck to pebble
 */
static void inbox_received_callback(DictionaryIterator *iterator, void *context) {
    window_destroy(main_menu_window);
    
    main_menu_window = window_create();
    
    TextLayer *text_layer = text_layer_create(GRect(0, 0, 144, 154));
    
    // Get the first pair
    Tuple *t = dict_read_first(iterator);
    
    // Process all pairs present
    while(t != NULL) {
        // Process this pair's key
        switch (t->key) {
            case 5:
                //APP_LOG(APP_LOG_LEVEL_INFO, "KEY_DATA received with value %d", (int)t->value->int32);
                text_layer_set_text(text_layer, t->value->cstring);
                break;
            default:
                //APP_LOG(APP_LOG_LEVEL_INFO, "KEY_DATA received with value %d", (int)t->value->int32);
                text_layer_set_text(text_layer, t->value->cstring);
                break;
        }
        
        // Get next pair, if any
        t = dict_read_next(iterator);
    }
    
    
    text_layer_set_font(text_layer, fonts_get_system_font(FONT_KEY_GOTHIC_28_BOLD));
    text_layer_set_text_alignment(text_layer, GTextAlignmentCenter);
    layer_add_child(window_get_root_layer(main_menu_window), text_layer_get_layer(text_layer));
    
    window_stack_push(main_menu_window, true);

}

//I don't know
void sync_error_callback(DictionaryResult dict_error, AppMessageResult app_message_error, void *context) {
    window_destroy(main_menu_window);
    
    main_menu_window = window_create();
    
    TextLayer *text_layer = text_layer_create(GRect(0, 0, 144, 154));
    text_layer_set_text(text_layer, "Sync error callback");
    text_layer_set_font(text_layer, fonts_get_system_font(FONT_KEY_GOTHIC_28_BOLD));
    text_layer_set_text_alignment(text_layer, GTextAlignmentCenter);
    layer_add_child(window_get_root_layer(main_menu_window), text_layer_get_layer(text_layer));
    
    window_stack_push(main_menu_window, true);
}

//Receive failed
static void inbox_dropped_callback(AppMessageResult reason, void *context) {
    window_destroy(main_menu_window);
    
    main_menu_window = window_create();
    
    TextLayer *text_layer = text_layer_create(GRect(0, 0, 144, 154));
    text_layer_set_text(text_layer, "inbox dropped the base");
    text_layer_set_font(text_layer, fonts_get_system_font(FONT_KEY_GOTHIC_28_BOLD));
    text_layer_set_text_alignment(text_layer, GTextAlignmentCenter);
    layer_add_child(window_get_root_layer(main_menu_window), text_layer_get_layer(text_layer));
    
    window_stack_push(main_menu_window, true);
}

//Main Window Load
static void add_deck_window_load(Window *window){
    Layer *window_layer = window_get_root_layer(window);
    GRect bounds = layer_get_frame(window_layer);
    
    if (bluetooth_connection_service_peek())
    {
        display_layer = text_layer_create(GRect(0, 0, 144, 154));
        text_layer_set_text(display_layer, "Connected to phone.");
        //text_layer_set_font(display_layer, fonts_get_system_font(FONT_KEY_GOTHIC_28_BOLD));   //enable to make larger title
        text_layer_set_text_alignment(display_layer, GTextAlignmentCenter); //center message
        layer_add_child(window_get_root_layer(add_deck_window), text_layer_get_layer(display_layer));
        
        display_layer = text_layer_create(GRect(0, 0, 144, 154));
        text_layer_set_text(display_layer, "Connected to phone!\nPlease select the deck you wish to have added to your Pebble from the iOS Companion App, 'Flashcards for Pebble' and click the share icon in the app's navigation bar.");
        text_layer_set_text_alignment(display_layer, GTextAlignmentCenter); //center message
        layer_add_child(window_get_root_layer(add_deck_window), text_layer_get_layer(display_layer));
        
    }
    else
    {
        display_layer = text_layer_create(GRect(0, 0, 144, 154));
        text_layer_set_text(display_layer, "Not connected to phone.\nPlease ensure that you have bluetooth enabled on your phone and on your Pebble.");
        text_layer_set_text_alignment(display_layer, GTextAlignmentCenter);
        layer_add_child(window_get_root_layer(add_deck_window), text_layer_get_layer(display_layer));
    }
}

//When main window unloads
static void add_deck_window_unload(Window *window) {
    text_layer_destroy(display_layer);
    window_destroy(add_deck_window);
}

//Open new window and display whether connected to phone
static void createAddDeckWindow()
{
    add_deck_window = window_create();
    
    window_set_window_handlers(add_deck_window, (WindowHandlers) {
        .load = add_deck_window_load,
        .unload = add_deck_window_unload,
    });
    
    
    window_stack_push(add_deck_window, true);
}

//Handles option select
static void menu_select_callback(MenuLayer *menu_layer, MenuIndex *cell_index, void *data) {
    // Use the row to specify which item will receive the select action
    switch (cell_index->section) {
            // This is the menu item with the cycling icon
        case 0:
            switch (cell_index->row) {
                case 0:
                    APP_LOG(APP_LOG_LEVEL_DEBUG, "0");
                    break;
                case 1:
                    APP_LOG(APP_LOG_LEVEL_DEBUG, "1");
                    break;
            }
            break;
        case 1:
            APP_LOG(APP_LOG_LEVEL_DEBUG, "default");
            createAddDeckWindow();
            break;
    }
}

//Main Window Load
static void main_window_load(Window *window){
    Layer *window_layer = window_get_root_layer(window);
    GRect bounds = layer_get_frame(window_layer);
    
    main_menu_layer = menu_layer_create(bounds);
    menu_layer_set_callbacks(main_menu_layer, NULL, (MenuLayerCallbacks){
        .get_num_sections = menu_get_num_sections_callback,
        .get_num_rows = menu_get_num_rows_callback,
        .get_header_height = menu_get_header_height_callback,
        .draw_header = menu_draw_header_callback,
        .draw_row = menu_draw_row_callback,
        .select_click = menu_select_callback,
    });
    
    // Bind the menu layer's click config provider to the window for interactivity
    menu_layer_set_click_config_onto_window(main_menu_layer, window);
    
    layer_add_child(window_layer, menu_layer_get_layer(main_menu_layer));
}

//When main window unloads
static void main_window_unload(Window *window) {
    // Destroy the menu layer
    menu_layer_destroy(main_menu_layer);
    /*main_menu_window = window_create();
    window_set_window_handlers(main_menu_window, (WindowHandlers) {
        .load = main_window_load,
        .unload = main_window_unload,
    });
    window_stack_push(main_menu_window, true);*/
}

//Creates Menu of Decks
static void createDeckSelectWindow()
{
    if (persist_exists(1))  //if decks exist
    {
        persist_read_data(1, decks, sizeof(decks));
        num_of_items = sizeof(decks);
    }
    else
    {
        num_of_items = 1;
        no_items = true;
        main_menu_window = window_create();
        window_set_window_handlers(main_menu_window, (WindowHandlers) {
            .load = main_window_load,
            .unload = main_window_unload,
        });
        window_stack_push(main_menu_window, true);
    }
}

static void init() {
    int inbound_size = app_message_inbox_size_maximum();
    int outbound_size = app_message_outbox_size_maximum();
    app_message_register_inbox_received(inbox_received_callback);
    app_message_register_inbox_dropped(inbox_dropped_callback);
    
    // Open AppMessage
    app_message_open(app_message_inbox_size_maximum(), app_message_outbox_size_maximum());

    //Create menu of decks
    createDeckSelectWindow();
}

static void deinit() {
    window_destroy(main_menu_window);
}

int main(void) {
    init();
    app_event_loop();
    deinit();
}
