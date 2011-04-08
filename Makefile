JC = /usr/bin/javac
JAR = /usr/bin/jar
MKDIR = /bin/mkdir -p
SCP = /usr/bin/scp

# Project title
TITLE = 
REMOTE_HOST = 
HADOOP_HOME = ${HOME}/hadoop

# The classes that need compiling
CLASSES = 

# This only works for 1 package.
# TODO: fix for 2 or more class files
PACKAGE := $(shell head -1 $(CLASSES) | cut -d" " -f2 | sed 's/\./\//g; s/;//')

.PHONY: send clean jar

all: $(TITLE)_classes $(TITLE)_classes/$(PACKAGE)/$(CLASSES:.java=.class)

jar: $(TITLE).jar

$(TITLE)_classes/$(PACKAGE)/%.class: %.java
	$(JC) -classpath $(HADOOP_HOME)/hadoop-0.20.2-core.jar:$(HADOOP_HOME)/lib/commons-cli-1.2.jar -d $(TITLE)_classes $<

$(TITLE)_classes:
	$(MKDIR) $(TITLE)_classes

%.jar: $(TITLE)_classes $(TITLE)_classes/$(PACKAGE)/$(CLASSES:.java=.class)
	$(JAR) -cvf $(TITLE).jar -C $(TITLE)_classes/ .

send: $(TITLE).jar
	$(SCP) $(TITLE).jar $(REMOTE_HOST):

clean:
	$(RM) -r $(TITLE)_classes
	$(RM) $(TITLE).jar
