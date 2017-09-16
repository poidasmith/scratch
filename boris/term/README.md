# Terminal Boris

A web-based terminal/console

* Each command is rendered as a widget/component
* Commands can be live/ticking
* 

Models
* users
* permissions
* table (self-describing object)
* function registry
* function call (timestamps, arguments, results)
* views 
    * functions and inputs
    * layout of function calls/results
    * view model for function results
* session (snapshot of a view)
    * can't directly edit live session
    

* app specific models
    * coins, wallets, transactions
    * events, logs, measurements, user actions
    * attributes, tags, metadata

Functions 
* functions take arguments of N models and return a single model (or a collection?)
* metadata: user, timestamp, session

Unknown command/typo: suggest

Examples:

* host functions
    * ls/dir as a table, sortable, filterable, live-updating/watch dir
    * ps as a table, add columns, sort by columns etc, filter
    * 

* redis api
    * caches, snaps of functions

* elastic api, attributes allow querying
    * store models in session indices
    * official models in data indices
        * official models are stored in git/persistent structures
        * function repository
        * code repository
        * how to prune git repos?
    * elastic index of git models? more queryable metadata

    

* crypto currencies
    * spvs
    * smart contracts

Dependencies


Grids
https://github.com/adazzle/react-data-grid

Material Design, Layouts, Widgets
https://www.muicss.com/docs/v1/react/introduction

Tree
https://github.com/chenglou/react-treeview

Editor
https://draftjs.org/

