# Data Boris

Models
- Config
- Process/Job
- Git Simplified
    - Module
    - Script
    - 
- Tables
- Wallet, SPVs
- Ethereum
    - Dapp, Smart Contracts
    - Collective behaviour


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
    * redux store persistent data structure
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

    