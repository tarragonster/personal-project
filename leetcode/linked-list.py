class Node:
    def __init__(self, data = None, next_node = None):
        self.data = data
        self.nextNode = next_node

    def get_data(self):
        return self.data

    def set_data(self, data):
        self.data = data

    def get_nextNode(self):
        return self.nextNode

    def set_nextNode(self, nextNode):
        self.nextNode = nextNode


class LinkedList:
    def __init__(self, head = None):
        self.head = head


    def add_Node(self, data):
        # if empty
        if self.head == None:
            self.head = Node(data)


        # not empty
        else:
            curr_Node = self.head

            # if node added is at the start
            if data < curr_Node.get_data():
                self.head = Node(data, curr_Node)

            # not at start
            else:
                while data > curr_Node.get_data() and curr_Node.get_nextNode() != None:
                    prev_Node = curr_Node
                    curr_Node = curr_Node.get_nextNode()

                # if node added is at the middle
                if data < curr_Node.get_data():
                    prev_Node.set_nextNode(Node(data, curr_Node))


                # if node added is at the last
                elif data > curr_Node.get_data() and curr_Node.get_nextNode() == None:
                    curr_Node.set_nextNode(Node(data))



    def search(self, data):
        curr_Node = self.head
        while curr_Node != None:
            if data == curr_Node.get_data():
                return True

            else:
                curr_Node = curr_Node.get_nextNode()

        return False


    def delete_Node(self, data):
        if self.search(data):
            # if data is found

            curr_Node = self.head
            #if node to be deleted is the first node
            if curr_Node.get_data() == data:
                self.head = curr_Node.get_nextNode()

            else:
                while curr_Node.get_data() != data:
                    prev_Node = curr_Node
                    curr_Node = curr_Node.get_nextNode()

                #node to be deleted is middle
                if curr_Node.get_nextNode() != None:
                    prev_Node.set_nextNode(curr_Node.get_nextNode())

                # node to be deleted is at the end
                elif curr_Node.get_nextNode() == None:
                    prev_Node.set_nextNode(None)

        else:
            return "Not found."

    def return_as_lst(self):
        lst = []
        curr_Node = self.head
        while curr_Node != None:
            lst.append(curr_Node.get_data())
            curr_Node = curr_Node.get_nextNode()

        return lst

    def size(self):
        curr_Node = self.head
        count = 0
        while curr_Node:
            count += 1
            curr_Node = curr_Node.get_nextNode()
        return count


## TEST CASES #
test1 = LinkedList()
test2 = LinkedList()
test1.add_Node(20)
test1.add_Node(15)
test1.add_Node(13)
test1.add_Node(14)
test1.delete_Node(17)
print(test1.return_as_lst())
print(test2.size())