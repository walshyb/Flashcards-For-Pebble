//
//  test.h
//  
//
//  Created by Brandon Walsh on 3/26/15.
//
//


#include "pebble.h"

static Window *main_menu_window;
static MenuLayer *main_menu_layer;

static Window *add_deck_window;
static TextLayer *display_layer;

struct Card
{
    char cardFront[1000];
    char cardBack[1000];
};

struct Deck
{
    char name[50];
    struct Card cards[10000];
};

struct Deck *decks[100];

//how many sections
static uint16_t menu_get_num_sections_callback(MenuLayer *menu_layer, void *data);

//items per section
static uint16_t menu_get_num_rows_callback(MenuLayer *menu_layer, uint16_t section_index, void *data);

//Height of menu
static int16_t menu_get_header_height_callback(MenuLayer *menu_layer, uint16_t section_index, void *data);

//Fill in section titles
static void menu_draw_header_callback(GContext* ctx, const Layer *cell_layer, uint16_t section_index, void *data);

//Display menu items
static void menu_draw_row_callback(GContext* ctx, const Layer *cell_layer, MenuIndex *cell_index, void *data);

//Received deck from iOS
static void inbox_received_callback(DictionaryIterator *iterator, void *context);

//I don't know
void sync_error_callback(DictionaryResult dict_error, AppMessageResult app_message_error, void *context);

//Receive failed
static void inbox_dropped_callback(AppMessageResult reason, void *context);

//Open new window and display whether connected to phone
static void createAddDeckWindow();

//Handles option select
static void menu_select_callback(MenuLayer *menu_layer, MenuIndex *cell_index, void *data);

//Main Window Load
static void main_window_load(Window *window);

//When main window unloads
static void main_window_unload(Window *window);

//Creates necessary layers
static void createDeckSelectWindow();

//Add Deck Window Load
static void add_deck_window_load(Window *window);

//Add Deck Window Unload
static void add_deck_window_unload(Window *window);