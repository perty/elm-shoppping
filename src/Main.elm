module Main exposing (Model, Msg(..), init, initialModel, main)

import Browser
import Catalog exposing (CatalogItem, catalogItems)
import Html exposing (Html, button, div, h1, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Money exposing (..)
import ShoppingCart exposing (ShoppingCart, ShoppingCartItem, addItem, cartValue, itemPrice, removeItem)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type Msg
    = AddToCart CatalogItem
    | RemoveCartItem ShoppingCartItem
    | AddCartItem ShoppingCartItem


type alias Model =
    { hello : String
    , cart : ShoppingCart
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    { hello = "Hello World"
    , cart = ShoppingCart []
    }



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddToCart catalogItem ->
            ( { model | cart = addItem model.cart catalogItem }, Cmd.none )

        RemoveCartItem item ->
            ( { model | cart = removeItem model.cart item }, Cmd.none )

        AddCartItem item ->
            ( { model | cart = addItem model.cart item }, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    div [ class "row" ]
        [ viewCatalog
        , viewCart model.cart
        ]


viewCatalog : Html Msg
viewCatalog =
    div [ class "col" ]
        [ h1 [] [ text "Catalog" ]
        , viewCatalogItems
        ]


viewCatalogItems : Html Msg
viewCatalogItems =
    table []
        [ thead []
            [ tr []
                [ th [ class "description" ] [ text "Description" ]
                , th [ class "price" ] [ text "Price" ]
                , th [] [ text "Add" ]
                ]
            ]
        , tbody [] (List.map viewCatalogItem catalogItems)
        ]


viewCatalogItem : CatalogItem -> Html Msg
viewCatalogItem item =
    tr []
        [ td [] [ text item.description ]
        , td [] [ text <| moneyToString item.price ]
        , td [] [ button [ onClick (AddToCart item) ] [ text "Add" ] ]
        ]


viewCart : ShoppingCart -> Html Msg
viewCart cart =
    div [ class "cart" ]
        [ div [] [ text "Shopping cart" ]
        , text <| "Number of items in cart: " ++ (String.fromInt <| List.sum <| List.map .quantity cart.items)
        , viewCartItems cart
        ]


viewCartItems : ShoppingCart -> Html Msg
viewCartItems cart =
    div [ class "col" ]
        [ table [ class "cartItems" ]
            [ thead []
                [ tr []
                    [ th [ class "description" ] [ text "Description" ]
                    , th [ class "price" ] [ text "Price" ]
                    , th [ class "quantity" ] [ text "Quantity" ]
                    , th [ class "total" ] [ text "Total" ]
                    ]
                ]
            , tbody [] (List.map viewCartItem cart.items)
            ]
        , div [ class "row-flex-end" ] [ div [] [ text <| moneyToString <| cartValue cart ] ]
        ]


viewCartItem : ShoppingCartItem -> Html Msg
viewCartItem item =
    tr []
        [ td [ class "description" ] [ text item.description ]
        , td [ class "price" ] [ text <| moneyToString item.price ]
        , td [ class "quantity" ] [ viewQuantityControl item ]
        , td [ class "total" ] [ text <| moneyToString (itemPrice item) ]
        ]


viewQuantityControl : ShoppingCartItem -> Html Msg
viewQuantityControl item =
    div [ class "row" ]
        [ button [ onClick (RemoveCartItem item) ] [ text "-" ]
        , text <| String.fromInt item.quantity
        , button [ onClick (AddCartItem item) ] [ text "+" ]
        ]



-- Subscription


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
