-- ============================================================================
-- Neovim Core Options Configuration
-- ============================================================================
-- This file contains core Neovim options organized by functionality.
-- Options are set using vim.opt (o) for most settings and vim.g (g) for globals.

local M = {}

local o = vim.opt
local g = vim.g

-- ============================================================================
-- LEADER KEY
-- ============================================================================
-- Set the leader key used for custom mappings
g.mapleader = ";"                    -- Use semicolon as leader key (default is backslash)

-- ============================================================================
-- USER INTERFACE
-- ============================================================================
-- Line numbers and visual elements
o.number = true                      -- Show absolute line numbers
o.relativenumber = false             -- Disable relative line numbers (shows distance from cursor)
o.termguicolors = true               -- Enable 24-bit RGB colors in the terminal
o.signcolumn = "yes"                 -- Always show sign column (prevents text shifting when signs appear)

-- ============================================================================
-- TEXT EDITING & INDENTATION
-- ============================================================================
-- Tab and indentation settings
o.expandtab = true                   -- Convert tabs to spaces
o.shiftwidth = 4                     -- Number of spaces for auto-indent (>>, <<, etc.)
o.tabstop = 4                        -- Number of spaces a tab character displays as
o.smartindent = true                 -- Automatically indent new lines based on syntax

-- Text wrapping settings
o.wrap = true                        -- Enable visual wrapping (no actual newlines added)
o.linebreak = true                   -- Break lines at word boundaries, not mid-word
o.showbreak = "↳  "                  -- Add a visible prefix for wrapped lines

-- ============================================================================
-- BUFFER MANAGEMENT
-- ============================================================================
o.hidden = true                      -- Allow switching buffers without saving changes

-- ============================================================================
-- FILE HANDLING & BACKUP
-- ============================================================================
-- Swap and backup files
o.swapfile = true                    -- Enable swap files for crash recovery
o.backup = true                      -- Create backup files before overwriting
o.writebackup = false                -- Don't create backup copy during write (backup is renamed instead)

-- Persistent undo
o.undofile = true                    -- Enable persistent undo history saved to disk, letting you undo across sessions

-- ============================================================================
-- PERFORMANCE & TIMING
-- ============================================================================
o.updatetime = 300                   -- Time in ms to wait before triggering CursorHold event and writing swap file

-- ============================================================================
-- CLIPBOARD INTEGRATION
-- ============================================================================
o.clipboard = "unnamedplus"          -- Use system clipboard for all yank/delete/put operations

return M
