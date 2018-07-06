<%= app_name %>_NIF_SRC_DIR := $(C_SRC_DIR)/<%= app_name %>
<%= app_name %>_NIF_SRC     := $(wildcard $(<%= app_name %>_NIF_SRC_DIR)/*.c)
<%= app_name %>_NIF_OBJ     := $(<%= app_name %>_NIF_SRC:.c=.o)
<%= app_name %>_NIF         := $(PRIV_DIR)/<%= app_name %>_nif.so

<%= app_name %>_NIF_CFLAGS ?= -fPIC -Wall -Wextra -O2
ifeq ($(MIX_ENV),prod)
else
<%= app_name %>_NIF_CFLAGS += -DDEBUG -g
endif

<%= app_name %>_NIF_LDFLAGS ?= -fPIC -shared -pedantic

ALL   += <%= app_name %>_nif
CLEAN += <%= app_name %>_nif_clean
PHONY += <%= app_name %>_nif <%= app_name %>_nif_clean

<%= app_name %>_nif: $(<%= app_name %>_NIF)

<%= app_name %>_nif_clean:
	$(RM) $(<%= app_name %>_NIF)
	$(RM) $(<%= app_name %>_NIF_OBJ)

$(<%= app_name %>_NIF): $(<%= app_name %>_NIF_OBJ)
	$(CC) $^ $(ERL_LDFLAGS) $(<%= app_name %>_NIF_LDFLAGS) -o $@

$(<%= app_name %>_NIF_SRC_DIR)/%.o: $(<%= app_name %>_NIF_SRC_DIR)/%.c
	$(CC) -c $(ERL_CFLAGS) $(<%= app_name %>_NIF_CFLAGS) -o $@ $<
