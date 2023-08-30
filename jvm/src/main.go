package main

import (
	"encoding/binary"
	"fmt"
	"io"
	"log"
	"os"
)



/*
 * 
 * CLASS LOADER
 * 
 */
type ClassLoader struct {
	r   io.Reader
	err error
}

// 4.1
type Class struct {
	ConstPool  ConstPool
	Name       string
	Super      string
	Flags      uint16
	Interfaces []string
	Fields     []Field
	Methods    []Field
	Attributes []Attribute
}

// 4.5
type Field struct {
	Flags      uint16
	Name       string
	Descriptor string
	Attributes []Attribute
}

// 4.7
type Attribute struct {
	Name string
	Data []byte
}

// 4.4
type Const struct {
	Tag              byte
	NameIndex        uint16
	ClassIndex       uint16
	NameAndTypeIndex uint16
	StringIndex      uint16
	DescIndex        uint16
	Integer          int32
	String           string
}

type ConstPool []Const

func (cp ConstPool) Resolve(index uint16) string {
	if cp[index-1].Tag == 0x01 {
		return cp[index-1].String
	}
	return ""
}

func (l *ClassLoader) bytes(n int) []byte {
	b := make([]byte, n, n)
	if l.err == nil {
		_, l.err = io.ReadFull(l.r, b)
	}
	return b
}
func (l *ClassLoader) u1() uint8  { return l.bytes(1)[0] }
func (l *ClassLoader) u2() uint16 { return binary.BigEndian.Uint16(l.bytes(2)) }
func (l *ClassLoader) u4() uint32 { return binary.BigEndian.Uint32(l.bytes(4)) }
func (l *ClassLoader) u8() uint64 { return binary.BigEndian.Uint64(l.bytes(8)) }

func (l *ClassLoader) cpInfo() (constPool ConstPool) {
	constPoolCount := l.u2()
	// 4.4-B; starts from 1
	for i := uint16(1); i < constPoolCount; i++ {
		c := Const{Tag: l.u1()}
		switch c.Tag {
		case 1: // 4.4.7
			c.String = string(l.bytes(int(l.u2())))
		case 3: // 4.4.4
			c.Integer = int32(l.u4())
		case 7: // 4.4.1
			c.NameIndex = l.u2()
		case 8: // 4.4.3
			c.StringIndex = l.u2()
		case 9, 10: // 4.4.2
			c.ClassIndex = l.u2()
			c.NameAndTypeIndex = l.u2()
		case 12: // 4.4.6
			c.NameIndex, c.DescIndex = l.u2(), l.u2()
		default:
			l.err = fmt.Errorf("unsupported tag: %d %d", c.Tag, i)
		}
		constPool = append(constPool, c)
	}
	return constPool
}

func (l *ClassLoader) interfaces(cp ConstPool) (interfaces []string) {
	interfaceCount := l.u2()
	for i := uint16(0); i < interfaceCount; i++ {
		interfaces = append(interfaces, cp.Resolve(l.u2()))
	}
	return interfaces
}

// 4.5
func (l *ClassLoader) fields(cp ConstPool) (fields []Field) {
	fieldsCount := l.u2()
	for i := uint16(0); i < fieldsCount; i++ {
		fields = append(fields, Field{
			Flags:      l.u2(),
			Name:       cp.Resolve(l.u2()),
			Descriptor: cp.Resolve(l.u2()),
			Attributes: l.attrs(cp),
		})
	}
	return fields
}

// 4.7
func (l *ClassLoader) attrs(cp ConstPool) (attrs []Attribute) {
	attributesCount := l.u2()
	for i := uint16(0); i < attributesCount; i++ {
		attrs = append(attrs, Attribute{
			Name: cp.Resolve(l.u2()),
			Data: l.bytes(int(l.u4())),
		})
	}
	return attrs
}

// Initialise
func (l *ClassLoader) Load(path string) (Class, error) {
	classfileReader, _ := os.Open(path)
	l.r = classfileReader
	c := Class{}
	l.u8() // magic(4), minor(2), major(2)
	cp := l.cpInfo()
	c.ConstPool = cp
	c.Flags = l.u2()
	c.Name = cp.Resolve(l.u2()) // this class
	c.Super = cp.Resolve(l.u2())
	c.Interfaces = l.interfaces(cp)
	c.Fields = l.fields(cp)
	c.Methods = l.fields(cp)
	c.Attributes = l.attrs(cp)
	return c, l.err
}



/*
 * 
 * RUNTIME DATA AREA
 * 
 */
type StackArea struct {
	Class *Class
}

type Value interface{}

// 2.6
type Frame struct {
	IP     uint32
	Code   []byte
	Locals []Value
	Stack  []Value
}

func (f *Frame) push(v Value) {
	f.Stack = append(f.Stack, v)
}

func (f *Frame) pop() Value {
	v := f.Stack[len(f.Stack)-1]
	f.Stack = f.Stack[:len(f.Stack)-1]
	return v
}

// Create frame instance
func (s StackArea) PushFrame(method string, args ...Value) Frame {
	for _, m := range s.Class.Methods {
		if m.Name == method {
			for _, a := range m.Attributes {
				if a.Name == "Code" && len(a.Data) > 8 {
					maxLocals := binary.BigEndian.Uint16(a.Data[2:4])
					frame := Frame{
						Code:   a.Data[8:],
						Locals: make([]Value, maxLocals, maxLocals),
					}
					for i := 0; i < len(args); i++ {
						frame.Locals[i] = args[i]
					}
					return frame
				}
			}
		}
	}
	panic("method not found")
}



/*
 * 
 * EXECUTION ENGINE
 *
 */
type Interpreter struct {}

func (i *Interpreter) getBranchBytes(frame *Frame) []int32 {
	branchbytes := make([]int32, 2)
	branchbytes[0] = int32(binary.BigEndian.Uint16(frame.Code[frame.IP+1:]) >> 8)
	branchbytes[1] = int32(binary.BigEndian.Uint16(frame.Code[frame.IP+2:]) >> 8)
	return branchbytes
}

// 6.5 + 7.1
func (i *Interpreter) Exec(frame *Frame) Value {
	for {
		op := frame.Code[frame.IP]
		switch op {
		//
		// Constants
		//
		case 0x03: // ICONST_0
			frame.push(int32(0))
		case 0x04: // ICONST_1
			frame.push(int32(1))
		case 0x07: // ICONST_4
			frame.push(int32(4))
		case 0x10: // BIPUSH
			value := int32(binary.BigEndian.Uint16(frame.Code[frame.IP+1:]) >> 8)
			frame.push(value)
			frame.IP = frame.IP + 1
		//
		// Loads & Stores
		//
		case 0x1A: // ILOAD_0
			frame.push(frame.Locals[0])
		case 0x1B: // ILOAD_1
			frame.push(frame.Locals[1])
		case 0x1C: // ILOAD_2
			frame.push(frame.Locals[2])
		case 0x1D: // ILOAD_3
			frame.push(frame.Locals[3])
		case 0x3B: // ISTORE_0
			value := frame.pop().(int32)
			frame.Locals[0] = value
		case 0x3C: // ISTORE_1
			value := frame.pop().(int32)
			frame.Locals[1] = value
		case 0x3D: // ISTORE_2
			value := frame.pop().(int32)
			frame.Locals[2] = value
		case 0x3E: // ISTORE_3
			value := frame.pop().(int32)
			frame.Locals[3] = value
		//
		// Math
		//
		case 0x60: // IADD
			value2 := frame.pop().(int32)
			value1 := frame.pop().(int32)
			frame.push(value1 + value2)
		case 0x78: // ISHL
			value2 := frame.pop().(int32)
			value1 := frame.pop().(int32)
			s := uint32(value2) & 0x1f // low five bits
			frame.push(value1 << s)
		case 0x84: // IINC
			index := uint32(binary.BigEndian.Uint16(frame.Code[frame.IP+1:]) >> 8)
			value := int8(binary.BigEndian.Uint16(frame.Code[frame.IP+2:]) >> 8)
			frame.Locals[index] = frame.Locals[index].(int32) + int32(value)
			frame.IP = frame.IP + 2
		//
		// Comparisons
		//
		case 0x9B: // IFLT
			value := frame.pop().(int32)
			branchbytes := i.getBranchBytes(frame)
			if value < 0 {
				frame.IP = uint32(int32(frame.IP) - 1 + branchbytes[1] - branchbytes[0]) // -1 because of increment at the end of the loop
			} else {
				frame.IP = frame.IP + 2
			}
		case 0x9E: // IFLE
			value := frame.pop().(int32)
			branchbytes := i.getBranchBytes(frame)
			if value <= 0 {
				frame.IP = uint32(int32(frame.IP) - 1 + branchbytes[1] - branchbytes[0]) // -1 because of increment at the end of the loop
			} else {
				frame.IP = frame.IP + 2
			}
		case 0xA2: //IF_CMPGE
			value2 := frame.pop().(int32)
			value1 := frame.pop().(int32)
			branchbytes := i.getBranchBytes(frame)
			if value1 >= value2 {
				frame.IP = uint32(int32(frame.IP) - 1 + branchbytes[1] - branchbytes[0]) // -1 because of increment at the end of the loop
			} else {
				frame.IP = frame.IP + 2
			}
		//
		// References
		//
		case 0xB8: // INVOKESTATIC (specific to blinky-jvm: runs always SetLeds)
			value := frame.pop().(int32)
			SetLeds(value)
			frame.IP = frame.IP + 2 // increment because of following bytebranchs
		//
		// Controls
		//
		case 0xA7: // GOTO
			branchbytes := i.getBranchBytes(frame)
			frame.IP = uint32(int32(frame.IP) - 2 + branchbytes[1] - branchbytes[0]) // -1 because of increment at the end of the loop
		case 0xAC: // IRETURN
			return frame.pop().(int32)
		case 0xB1: // RETURN
			return nil
		}

		frame.IP++

		// Optional Logs
		isActive := false
		if isActive {
			log.Printf("OP:%02x", op)
			log.Printf("STACK:%v", frame.Stack)
			log.Printf("LOCALS:%v", frame.Locals)
			log.Printf("NEXT IP:%v", frame.IP)
			log.Printf("+++++++++++++++++++++")
		}
	}
}

func main() {
	// Loading Process
	classLoader := ClassLoader{}
	class, _ := classLoader.Load("../java/Blinky.class") // class instance is part of Runtime Data Area

	// Runtime Data Area
	a := int32(2)
	b := int32(3)
	stackArea := StackArea{&class}
	frame := stackArea.PushFrame("main", a, b)

	// Execution Process
	interpreter := Interpreter{}
	response := interpreter.Exec(&frame)
	log.Printf("Simulation finished with %v led calls.", response)
}
